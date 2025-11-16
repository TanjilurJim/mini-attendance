<?php 
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\Log;

Broadcast::channel('attendance', function ($user) {
    // Log for debugging
    Log::info('Broadcasting auth attempt', [
        'user_id' => $user ? $user->id : null,
        'authenticated' => (bool) $user
    ]);
    
    // Return true if user exists (is authenticated)
    return (bool) $user;
});