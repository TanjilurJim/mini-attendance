<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class BroadcastAuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_broadcasting_auth_with_token()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;

        $this->withHeader('Authorization', "Bearer {$token}")
             ->postJson('/api/broadcasting/auth', [
                 'socket_id' => '1234.5678',
                 'channel_name' => 'private-attendance'
             ])->assertStatus(200);
    }
}
