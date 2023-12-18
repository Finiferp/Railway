<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\playerController;
use App\Http\Controllers\goodController;
use App\Http\Controllers\assetController;
use App\Http\Controllers\worldController;
use App\Http\Controllers\trainController;
use App\Http\Controllers\railwayController;
use App\Http\Controllers\industryController;
use App\Http\Controllers\stationController;
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

    Route::post('/register', [playerController::class, 'register']);
    Route::post('/login', [playerController::class, 'login']);

    Route::middleware('auth.token')->group(function () {
        Route::get('/player/{id}', [playerController::class, 'getPlayerById']);
        Route::get('/players', [playerController::class, 'getAllPlayers']);
        Route::post('/player/stockpile',[playerController::class,'getPlayerStockpile']);
        Route::post('/player/needs',[playerController::class,'getPlayerNeeds']);
        Route::post('/player/railways',[playerController::class,'getPlayerRailways']);
        Route::post('/player/trains',[playerController::class,'getPlayerTrains']);
        Route::post('/player/industries',[playerController::class,'getPlayerIndustries']);
        
        Route::get('/good/{id}', [goodController::class,'getGoodById']);
        Route::get('/goods',[goodController::class,'getAllGoods']);

        //Route::post('/asset/create',[assetController::class, 'createAsset']);
        Route::get('/asset/{id}', [assetController::class,'getAssetById']);
        Route::get('/assets',[assetController::class,'getAllAssets']);
        Route::get('/asset/player/{id}',[assetController::class,'getPlayerAssets']);
        Route::get('/asset/world/{id}',[assetController::class,'getWorldAssets']);
        Route::post('/asset/buy',[assetController::class,'buyAsset']);
        Route::post('/asset/station',[assetController::class,'getAssetsStation']);


        Route::get('/world/{id}', [worldController::class,'getWorldById']);
        Route::get('/worlds',[worldController::class,'getAllWorlds']);

        Route::post('/train/create',[trainController::class, 'createTrain']);
        Route::get('/train/{id}', [trainController::class,'getTrainById']);
        Route::get('/trains',[trainController::class,'getAllTrains']);
        Route::post('/train/deman',[trainController::class,'demandTrain']);
        Route::delete('/train/delete',[trainController::class,'deleteTrain']);


        Route::post('/station/create',[stationController::class, 'createStation']);
        Route::get('/station/{id}', [stationController::class,'getStationById']);
        Route::get('/stations',[stationController::class,'getAllStations']);
        Route::post('/station/name',[stationController::class,'getStationByName']);

        Route::post('/railway/create',[railwayController::class, 'createRailway']);
        Route::get('/railway/{id}', [railwayController::class,'getRailwayById']);
        Route::get('/railways',[railwayController::class,'getAllRailways']);

        Route::post('/industry/create',[industryController::class, 'createIndustry']);
        Route::get('/industry/{id}', [industryController::class,'getIndustryById']);
        Route::get('/industries',[industryController::class,'getAllIndustries']);
    });