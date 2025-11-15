<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\User;
use App\Http\Controllers\Api\ReportController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Simple, token-based routes for the mini-attendance API.
|
*/

// Public: create personal access token (login)
Route::post('/sanctum/token', function (Request $request) {
    $request->validate([
        'email' => 'required|email',
        'password' => 'required|string',
        'device_name' => 'required|string',
    ]);

    $user = User::where('email', $request->email)->first();

    if (! $user || ! Hash::check($request->password, $user->password)) {
        throw ValidationException::withMessages([
            'email' => ['The provided credentials are incorrect.'],
        ]);
    }

    $token = $user->createToken($request->device_name, ['*'])->plainTextToken;

    return response()->json([
        'token' => $token,
        'token_type' => 'Bearer',
        'user' => $user,
    ], 201);
});

// Health
Route::get('/health', function () {
    return response()->json(['ok' => true]);
});

// Protected API routes (require Bearer token)
Route::middleware('auth:sanctum')->group(function () {

    Route::get('attendance/report', [ReportController::class, 'export']);


    // Student resource
    Route::apiResource('students', \App\Http\Controllers\Api\StudentController::class);

    // Attendance endpoints
    Route::post('attendance/bulk', [\App\Http\Controllers\Api\AttendanceController::class, 'storeBulk']);
    Route::get('attendance/today-summary', [\App\Http\Controllers\Api\AttendanceController::class, 'todaySummary']);
    Route::get('attendance', [\App\Http\Controllers\Api\AttendanceController::class, 'index']);
    Route::get('attendance/monthly-report', [\App\Http\Controllers\Api\AttendanceController::class, 'monthlyReport']);

    // token revoke endpoints
    Route::post('/sanctum/revoke', function (Request $request) {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Token revoked'], 200);
    });

    Route::post('/sanctum/revoke-all', function (Request $request) {
        $request->user()->tokens()->delete();
        return response()->json(['message' => 'All tokens revoked'], 200);
    });
});
