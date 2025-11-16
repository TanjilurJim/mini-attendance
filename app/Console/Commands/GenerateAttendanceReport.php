<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\AttendanceService;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;
use Carbon\Carbon;

class GenerateAttendanceReport extends Command
{
    /**
     * The name and signature of the console command.
     *
     * month optional, class optional
     */
    protected $signature = 'attendance:generate-report {month?} {class?}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Generate monthly attendance report CSVs for a given month (Y-m) and optional class.';

    protected AttendanceService $attendanceService;

    public function __construct(AttendanceService $attendanceService)
    {
        parent::__construct();
        $this->attendanceService = $attendanceService;
    }

    public function handle()
    {
        $raw = trim((string) $this->argument('month'));

        // if no month provided, use current month
        if ($raw === '') {
            $monthCarbon = Carbon::now()->startOfMonth();
        } else {
            // normalize inputs
            // 1) YYYY-MM  -> accept
            // 2) YYYYMM   -> convert to YYYY-MM
            // 3) MM or M  -> use current year (e.g. "7" => 2025-07)
            // reject anything else

            if (preg_match('/^\d{4}-\d{2}$/', $raw)) {
                // e.g. 2025-07
                try {
                    $monthCarbon = Carbon::createFromFormat('Y-m', $raw);
                } catch (\Exception $e) {
                    $this->error("Invalid month value: {$raw}. Expected YYYY-MM or MM.");
                    return 1;
                }
            } elseif (preg_match('/^\d{6}$/', $raw)) {
                // e.g. 202507 -> convert to 2025-07
                $norm = substr($raw, 0, 4) . '-' . substr($raw, 4, 2);
                try {
                    $monthCarbon = Carbon::createFromFormat('Y-m', $norm);
                } catch (\Exception $e) {
                    $this->error("Invalid month value: {$raw}. Expected YYYYMM, YYYY-MM or MM.");
                    return 1;
                }
            } elseif (preg_match('/^\d{1,2}$/', $raw)) {
                // e.g. 7 or 07 -> current year + month
                $monthNum = (int) $raw;
                if ($monthNum < 1 || $monthNum > 12) {
                    $this->error("Invalid month number: {$raw}. Must be 1-12.");
                    return 1;
                }
                $year = Carbon::now()->year;
                $norm = sprintf('%04d-%02d', $year, $monthNum);
                try {
                    $monthCarbon = Carbon::createFromFormat('Y-m', $norm);
                } catch (\Exception $e) {
                    $this->error("Invalid month value: {$raw}.");
                    return 1;
                }
            } else {
                $this->error("Invalid month format. Acceptable formats: YYYY-MM, YYYYMM, or MM (uses current year). Example: 2025-11 or 202511 or 11");
                return 1;
            }
        }

        // now we have $monthCarbon (start of month). Format for use:
        $month = $monthCarbon->format('Y-m');
        $labelClass = $this->argument('class') ?: 'all';
        
        $classArg = $this->argument('class') ?: null;
     

        $timestamp = now()->format('Ymd_His');
        $reportsDir = storage_path('app/reports');

        // ensure directory exists
        File::ensureDirectoryExists($reportsDir);

        // --- 1) Summary per student ---
        $this->info("Generating per-student monthly summary for {$month} (class: {$labelClass})...");
        $summaryRows = $this->attendanceService->getMonthlySummaryPerStudent($month, $classArg);

        $summaryFilename = "attendance_summary_{$month}_{$labelClass}_{$timestamp}.csv";
        $summaryPath = $reportsDir . DIRECTORY_SEPARATOR . $summaryFilename;

        $summaryHandle = fopen($summaryPath, 'w');

        // header
        fputcsv($summaryHandle, [
            'student_id',
            'student_name',
            'class',
            'section',
            'present_count',
            'absent_count',
            'late_count',
            'month_days',
            'present_percentage'
        ]);

        $daysInMonth = $monthCarbon->daysInMonth;

        foreach ($summaryRows as $row) {
            // row may have 'student' relation loaded
            $student = $row->student ?? null;
            $studentName = $student->name ?? ($row->student_id ?? '');
            $studentClass = $student->class ?? '';
            $studentSection = $student->section ?? '';

            $present = (int) ($row->present_count ?? 0);
            $absent = (int) ($row->absent_count ?? 0);
            $late = (int) ($row->late_count ?? 0);

            $percent = $daysInMonth ? round(($present / $daysInMonth) * 100, 2) : 0;

            fputcsv($summaryHandle, [
                $row->student_id,
                $studentName,
                $studentClass,
                $studentSection,
                $present,
                $absent,
                $late,
                $daysInMonth,
                $percent
            ]);
        }

        fclose($summaryHandle);

        $this->info("Summary CSV written to: storage/app/reports/{$summaryFilename}");

        // --- 2) Detailed rows ---
        $this->info("Generating detailed attendance rows for {$month} (class: {$labelClass})...");
        $detailedRows = $this->attendanceService->getMonthlyReport($month, $classArg);

        $detailedFilename = "attendance_detailed_{$month}_{$labelClass}_{$timestamp}.csv";
        $detailedPath = $reportsDir . DIRECTORY_SEPARATOR . $detailedFilename;

        $detailedHandle = fopen($detailedPath, 'w');

        fputcsv($detailedHandle, [
            'date',
            'student_id',
            'student_name',
            'class',
            'section',
            'status',
            'note',
            'recorded_by',
            'created_at'
        ]);

        foreach ($detailedRows as $r) {
            $student = $r->student ?? null;
            $studentName = $student->name ?? '';
            $studentClass = $student->class ?? '';
            $studentSection = $student->section ?? '';

            fputcsv($detailedHandle, [
                $r->date->toDateString(),
                $r->student_id,
                $studentName,
                $studentClass,
                $studentSection,
                $r->status,
                $r->note ?? '',
                $r->recorded_by ?? '',
                optional($r->created_at)->toDateTimeString() ?? ''
            ]);
        }

        fclose($detailedHandle);

        $this->info("Detailed CSV written to: storage/app/reports/{$detailedFilename}");

        $this->info("Report generation complete.");
        $this->line("Files saved to: storage/app/reports/");
        $this->line("Summary: {$summaryFilename}");
        $this->line("Detailed: {$detailedFilename}");

        return 0;
    }
}
