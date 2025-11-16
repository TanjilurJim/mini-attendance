<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Student;
use Illuminate\Foundation\Testing\RefreshDatabase;

class BulkAttendanceTest extends TestCase
{
    use RefreshDatabase;

    public function test_bulk_attendance_records_rows()
    {
        // create a user and students
        $user = User::factory()->create();
        $students = Student::factory()->count(3)->create();

        // create token for auth:sanctum
        $token = $user->createToken('test')->plainTextToken;

        $records = $students->map(fn($s) => [
            'student_id' => $s->id,
            'date' => now()->toDateString(),
            'status' => 'present',
        ])->toArray();

        $response = $this->withHeader('Authorization', "Bearer {$token}")
             ->postJson('/api/attendance/bulk', ['records' => $records]);

        $response->assertStatus(201);

        $this->assertDatabaseCount('attendances', 3);
    }
}
