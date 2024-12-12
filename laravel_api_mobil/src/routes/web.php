<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\MobilController;
use App\Http\Controllers\DataDosenController;

Route::get('/', function () {
    return view('welcome');
});

Route::group(['prefix' => 'api/v1/account'], function() {
    Route::get('/', [UserController::class, 'index']);
    Route::get('/{id}', [UserController::class, 'get_user']);
    Route::post('/', [UserController::class, 'create']);
    Route::post('/login', [UserController::class, 'login']);
    Route::put('/{id}', [UserController::class, 'update']);
    Route::delete('/{id}', [UserController::class, 'delete']);
});

Route::group(['prefix' => 'api/v1/dosen'], function() {
    Route::get('/', [DataDosenController::class, 'index']);
    Route::get('/{id}', [DataDosenController::class, 'get_dosen']);
    Route::post('/', [DataDosenController::class, 'create']);
    Route::put('/{id}', [DataDosenController::class, 'update']);
    Route::delete('/{id}', [DataDosenController::class, 'delete']);
});

Route::group(['prefix' => 'api/v1/mobil'], function() {
    Route::get('/', [MobilController::class, 'index']);
    Route::get('/{id}', [MobilController::class, 'get_mobil']);
    Route::post('/', [MobilController::class, 'create']);
    Route::put('/{id}', [MobilController::class, 'update']);
    Route::delete('/{id}', [MobilController::class, 'delete']);
});
