<?php

namespace App\Services;

use App\Models\Attendance;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class AttendanceService
{

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
    }

    public function getMonthlyReport(string $month, ?string $class = null)
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
