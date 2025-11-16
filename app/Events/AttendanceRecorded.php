<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel; // use PrivateChannel for auth
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class AttendanceRecorded implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    // minimal payload to send to clients
    public array $payload;

    /**
     * Create a new event instance.
     *
     * $payload example: ['class' => '8', 'count' => 12, 'sample' => [...]]
     */
    public function __construct(array $payload)
    {
        $this->payload = $payload;
    }

    /**
     * The channel the event should broadcast on.
     * We'll use a private channel so only authenticated users can listen.
     */
    public function broadcastOn()
    {
        // one global private channel for attendance notifications
        return new PrivateChannel('attendance');
        // Alternatively class-specific: new PrivateChannel("attendance.class.{$this->payload['class']}");
    }

    /**
     * Event name (client will listen for 'attendance.recorded').
     */
    public function broadcastAs()
    {
        return 'attendance.recorded';
    }

    /**
     * Data to broadcast.
     */
    public function broadcastWith()
    {
        return $this->payload;
    }
}
