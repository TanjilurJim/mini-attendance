
<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Single catch-all route for Vue SPA
| All navigation handled by Vue Router
|
*/

Route::get('/{any}', function () {
    return view('spa');
})->where('any', '.*');