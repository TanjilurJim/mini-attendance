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
        $monthArg = $this->argument('month') ?? now()->format('Y-m');
        $classArg = $this->argument('class') ?: null;

        // Validate month format (Y-m)
        try {
            $monthCarbon = Carbon::createFromFormat('Y-m', $monthArg);
        } catch (\Exception $e) {
            $this->error("Invalid month format. Expected Y-m (e.g. 2025-11).");
            return 1;
        }

        $month = $monthCarbon->format('Y-m');
        $labelClass = $classArg ?: 'all';

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
