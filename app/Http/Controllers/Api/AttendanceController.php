<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Services\AttendanceService;
use Illuminate\Http\Request;
use App\Http\Requests\StoreBulkAttendanceRequest;
use App\Http\Requests\MonthlyReportRequest;
use App\Http\Resources\AttendanceResource;

class AttendanceController extends Controller
{
    protected $service;

    public function __construct(AttendanceService $service)
    {
        $this->service = $service;
    }

    public function storeBulk(StoreBulkAttendanceRequest $request)
    {
        $this->service->recordBulk($request->validated()['records'], auth()->id());
        return response()->json(['message' => 'Attendance saved'], 201);
    }

    public function index(Request $request)
    {
        $q = Attendance::with('student')
            ->orderBy('date', 'desc')
            ->paginate(20);

        return AttendanceResource::collection($q);
    }

    public function todaySummary()
    {
        return response()->json($this->service->todaySummary());
    }

    public function monthlyReport(MonthlyReportRequest $request)
    {
        $month = $request->month; // 'YYYY-MM'
        $class = $request->class;

        $data = $this->service->getMonthlyReportData($month, $class);

        return response()->json($data);
    }
    public function update(Request $req, Attendance $attendance)
    {
        $req->validate(['status' => 'required|in:present,absent,late', 'note' => 'nullable|string']);

        $attendance->update([
            'status' => $req->status,
            'note'   => $req->note,
            'recorded_by' => $req->user()->id,
        ]);

        // Invalidate cache for the month/class of this attendance
        $month = substr($attendance->date, 0, 7); // 'YYYY-MM'
        $class = $attendance->student->class ?? null;

        $this->service->invalidateMonthlyCacheForMonths([$month], $class ? [$class] : null);

        return response()->json(['message' => 'Updated']);
    }
}
