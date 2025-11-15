<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\AttendanceService;
use Carbon\Carbon;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ReportController extends Controller
{
    protected AttendanceService $attendanceService;

    public function __construct(AttendanceService $attendanceService)
    {
        $this->attendanceService = $attendanceService;
    }

    /**
     * Preview or download attendance report.
     *
     * Query params:
     *  - month (Y-m) optional, defaults to current month
     *  - class optional
     *  - type: summary (per-student summary) | detailed (per-row). Default: summary
     *  - format: json | csv. Default: json (preview). csv => attachment download
     */
    public function export(Request $request)
    {
        $month = $request->query('month', now()->format('Y-m'));
        $class = $request->query('class', null);
        $type = $request->query('type', 'summary'); // summary|detailed
        $format = $request->query('format', 'json'); // json|csv

        try {
            $monthCarbon = Carbon::createFromFormat('Y-m', $month);
        } catch (\Throwable $e) {
            return response()->json(['message' => 'Invalid month format, expected Y-m'], 422);
        }

        if ($type === 'detailed') {
            // returns Collection of Attendance models with('student')
            $rows = $this->attendanceService->getMonthlyReport($month, $class);
            if ($format === 'json') {
                // return as JSON for preview
                return response()->json([
                    'type' => 'detailed',
                    'month' => $month,
                    'class' => $class,
                    'rows' => $rows->map(function ($r) {
                        return [
                            'date' => $r->date->toDateString(),
                            'student_id' => $r->student_id,
                            'student_name' => optional($r->student)->name,
                            'class' => optional($r->student)->class,
                            'section' => optional($r->student)->section,
                            'status' => $r->status,
                            'note' => $r->note,
                            'recorded_by' => $r->recorded_by,
                            'created_at' => optional($r->created_at)->toDateTimeString(),
                        ];
                    }),
                ]);
            } else {
                // stream CSV download
                $filename = "attendance_detailed_{$month}_" . ($class ?: 'all') . '.csv';
                $response = new StreamedResponse(function () use ($rows) {
                    $out = fopen('php://output', 'w');
                    fputcsv($out, ['date','student_id','student_name','class','section','status','note','recorded_by','created_at']);
                    foreach ($rows as $r) {
                        fputcsv($out, [
                            $r->date->toDateString(),
                            $r->student_id,
                            optional($r->student)->name,
                            optional($r->student)->class,
                            optional($r->student)->section,
                            $r->status,
                            $r->note ?? '',
                            $r->recorded_by ?? '',
                            optional($r->created_at)->toDateTimeString() ?? '',
                        ]);
                    }
                    fclose($out);
                });

                $response->headers->set('Content-Type', 'text/csv; charset=utf-8');
                $response->headers->set('Content-Disposition', "attachment; filename=\"{$filename}\"");
                return $response;
            }
        }

        // default: summary per student
        $summaryRows = $this->attendanceService->getMonthlySummaryPerStudent($month, $class);

        if ($format === 'json') {
            return response()->json([
                'type' => 'summary',
                'month' => $month,
                'class' => $class,
                'rows' => $summaryRows->map(function ($r) {
                    return [
                        'student_id' => $r->student_id,
                        'student_name' => optional($r->student)->name,
                        'class' => optional($r->student)->class,
                        'section' => optional($r->student)->section,
                        'present_count' => (int) ($r->present_count ?? 0),
                        'absent_count' => (int) ($r->absent_count ?? 0),
                        'late_count' => (int) ($r->late_count ?? 0),
                    ];
                }),
            ]);
        } else {
            $filename = "attendance_summary_{$month}_" . ($class ?: 'all') . '.csv';
            $response = new StreamedResponse(function () use ($summaryRows, $month) {
                $out = fopen('php://output', 'w');
                fputcsv($out, ['student_id','student_name','class','section','present_count','absent_count','late_count']);
                foreach ($summaryRows as $r) {
                    fputcsv($out, [
                        $r->student_id,
                        optional($r->student)->name,
                        optional($r->student)->class,
                        optional($r->student)->section,
                        (int) ($r->present_count ?? 0),
                        (int) ($r->absent_count ?? 0),
                        (int) ($r->late_count ?? 0),
                    ]);
                }
                fclose($out);
            });

            $response->headers->set('Content-Type', 'text/csv; charset=utf-8');
            $response->headers->set('Content-Disposition', "attachment; filename=\"{$filename}\"");
            return $response;
        }
    }
}
