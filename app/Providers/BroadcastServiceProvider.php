<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Broadcast;

class BroadcastServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap broadcasting services.
     */
    public function boot(): void
    {
        // IMPORTANT: register broadcast auth routes with 'auth:sanctum'
        // so Bearer tokens (Personal Access Tokens) will authenticate.
        Broadcast::routes(['middleware' => ['auth:sanctum']]);

        // Load channel definitions (routes/channels.php)
        if (file_exists(base_path('routes/channels.php'))) {
            require base_path('routes/channels.php');
        }
    }
}
