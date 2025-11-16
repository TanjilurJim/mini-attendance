<?php

namespace App\Services;

use App\Models\Attendance;
use App\Models\Student;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Collection;
use App\Events\AttendanceRecorded;

class AttendanceService
{
    protected int $ttl;

    public function __construct()
    {
        $this->ttl = (int) config('attendance.monthly_report_ttl', 3600);
    }

    /**
     * Record bulk attendance (upsert) and invalidate related caches.
     *
     * $records: array of ['student_id','date','status','note'?(optional)]
     */
    public function recordBulk(array $records, $userId)
    {
        // prepare rows
        $now = now();
        $rows = array_map(function ($r) use ($userId, $now) {
            return [
                'student_id' => $r['student_id'],
                'date' => $r['date'],
                'status' => $r['status'],
                'note' => $r['note'] ?? null,
                'recorded_by' => $userId,
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }, $records);

        // Use upsert (single query). Unique key must exist on student_id + date.
        Attendance::upsert($rows, ['student_id', 'date'], ['status', 'note', 'recorded_by', 'updated_at']);

        // Invalidate caches for affected months/classes
        $dates = array_unique(array_map(fn($r) => $r['date'], $records));
        $months = array_unique(array_map(fn($d) => substr($d, 0, 7), $dates)); // YYYY-MM

        $studentIds = array_unique(array_map(fn($r) => $r['student_id'], $records));
        $classes = Student::whereIn('id', $studentIds)->pluck('class')->unique()->toArray();

        $this->invalidateMonthlyCacheForMonths($months, $classes);

        /*
     * Broadcast / dispatch an attendance event so frontend can react in real-time.
     * Payload is intentionally small so clients can choose to fetch fresh data if needed.
     */
        try {
            $payload = [
                'class' => $classes[0] ?? 'all',
                'months' => $months,
                'count' => count($rows),
                'sample' => $rows[0] ?? null,
            ];

            // dispatch the event (will broadcast if the event implements ShouldBroadcast)
            event(new AttendanceRecorded($payload));
        } catch (\Throwable $e) {
            // don't break the main flow on broadcast errors; log for debugging
            \Log::error('Failed to dispatch AttendanceRecorded event', ['error' => $e->getMessage()]);
        }
    }

    /**
     * Raw DB retrieval of row models (unchanged)
     * returns Collection of Attendance models with('student')
     */
    public function getMonthlyReport(string $month, ?string $class = null): Collection
    {
        $start = Carbon::parse($month . '-01')->startOfMonth();
        $end   = Carbon::parse($month . '-01')->endOfMonth();

        $q = Attendance::with('student')
            ->whereBetween('date', [$start->toDateString(), $end->toDateString()])
            ->orderBy('date')
            ->orderBy('student_id');

        if ($class) {
            $q->whereHas('student', fn($s) => $s->where('class', $class));
        }

        return $q->get();
    }

    /**
     * Cached version that returns the *computed* daily stats array
     * suitable for API responses and safe to cache.
     *
     * return: ['daily_stats' => [ 'YYYY-MM-DD' => ['present'=>x,'absent'=>y,'late'=>z], ... ]]
     */
    public function getMonthlyReportData(string $month, ?string $class = null): array
    {
        $key = $this->monthlyCacheKey($month, $class);

        return Cache::remember($key, $this->ttl, function () use ($month, $class) {
            // Use the existing service method to get rows
            $rows = $this->getMonthlyReport($month, $class);

            // Build daily aggregated array
            $daily = $rows->groupBy(function ($r) {
                // $r->date is Carbon - convert to date string
                return $r->date->toDateString();
            })->mapWithKeys(function ($group, $date) {
                $present = $group->where('status', 'present')->count();
                $absent  = $group->where('status', 'absent')->count();
                $late    = $group->where('status', 'late')->count();
                return [$date => ['present' => $present, 'absent' => $absent, 'late' => $late]];
            });

            // Ensure every day in the month exists (0 values) so frontend charts are stable
            $start = Carbon::parse($month . '-01')->startOfMonth();
            $end = Carbon::parse($month . '-01')->endOfMonth();
            $period = \Carbon\CarbonPeriod::create($start, $end);

            $result = [];
            foreach ($period as $d) {
                $ds = $d->toDateString();
                $result[$ds] = $daily->get($ds, ['present' => 0, 'absent' => 0, 'late' => 0]);
            }

            return ['daily_stats' => $result];
        });
    }

    protected function monthlyCacheKey(string $month, ?string $class = null): string
    {
        $classPart = $class ? (string)$class : 'all';
        return "monthly_report:{$month}:{$classPart}";
    }

    /**
     * Invalidate monthly cache keys for a list of months and optional list of classes.
     * $months: ['2025-11', '2025-12']
     * $classes: ['6', '8'] or null for no per-class invalidation
     */
    public function invalidateMonthlyCacheForMonths(array $months, ?array $classes = null): void
    {
        foreach ($months as $month) {
            // forget the 'all' key
            Cache::forget($this->monthlyCacheKey($month, null));

            if ($classes) {
                foreach ($classes as $class) {
                    Cache::forget($this->monthlyCacheKey($month, $class));
                }
            }
        }
    }

    // existing getMonthlySummaryPerStudent() and todaySummary() remain unchanged...
    public function getMonthlySummaryPerStudent(string $month, ?string $class = null)
    {
        $start = Carbon::parse($month)->startOfMonth();
        $end = Carbon::parse($month)->endOfMonth();

        $q = Attendance::selectRaw('student_id')
            ->selectRaw("SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) as present_count")
            ->selectRaw("SUM(CASE WHEN status = 'absent' THEN 1 ELSE 0 END) as absent_count")
            ->selectRaw("SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END) as late_count")
            ->whereBetween('date', [$start, $end])
            ->groupBy('student_id');

        if ($class) {
            $q->whereHas('student', fn($s) => $s->where('class', $class));
        }

        return $q->with('student')->get();
    }

    public function todaySummary()
    {
        $today = Carbon::today()->toDateString();

        $row = DB::table('attendances')
            ->selectRaw('COUNT(*) as total')
            ->selectRaw("SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) as present")
            ->selectRaw("SUM(CASE WHEN status = 'absent' THEN 1 ELSE 0 END) as absent")
            ->selectRaw("SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END) as late")
            ->where('date', $today)
            ->first();

        $total = (int) ($row->total ?? 0);
        $present = (int) ($row->present ?? 0);

        return [
            'date' => $today,
            'total' => $total,
            'present' => $present,
            'absent' => (int) ($row->absent ?? 0),
            'late' => (int) ($row->late ?? 0),
            'percentage' => $total ? round(($present / $total) * 100, 2) : 0
        ];
    }
}
