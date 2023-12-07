<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\playerController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


    Route::get('/player/{id}', [playerController::class, 'getPlayerById']);
    Route::get('/players', [playerController::class, 'getAllPlayers']);
    Route::post('/register', [playerController::class, 'register']);
    Route::post('/login', [playerController::class, 'login']);


