<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class MonthlyReportTest extends TestCase
{
    use RefreshDatabase;

    public function test_monthly_report_returns_daily_stats()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;
        $month = now()->format('Y-m');

        $resp = $this->withHeader('Authorization', "Bearer {$token}")
            ->getJson("/api/attendance/monthly-report?month={$month}");

        $resp->assertStatus(200)
            ->assertJsonStructure(['daily_stats']);
    }
}
