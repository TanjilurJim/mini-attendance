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
        $rows = $this->service->getMonthlyReport($request->month, $request->class);
        // rows is a Collection of Attendance models (with('student'))

        $daily = $rows->groupBy(function ($r) {
            return $r->date->toDateString();
        })->mapWithKeys(function ($group, $date) {
            $present = $group->where('status', 'present')->count();
            $absent = $group->where('status', 'absent')->count();
            $late = $group->where('status', 'late')->count();
            return [$date => ['present' => $present, 'absent' => $absent, 'late' => $late]];
        });

        return response()->json(['daily_stats' => $daily]);
    }
}
