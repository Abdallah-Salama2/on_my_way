<?php

use App\Http\Controllers\Auth\ForgotPasswordController;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('/users', [Controller::class, 'index']);
Route::get('/reset-password', function (Request $request) {
    return view('reset-password');
})->name('password.reset');

Route::get('/password/success', [ForgotPasswordController::class, 'passwordSuccess'])->name('password.success');
