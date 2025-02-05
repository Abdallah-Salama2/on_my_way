<?php

use App\Http\Controllers\Auth\EmailController;
use App\Http\Controllers\Auth\ForgotPasswordController;
use App\Http\Controllers\Auth\UserAuthController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\Controller;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\FavoritesController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\RideController;
use App\Http\Controllers\StoreController;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

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

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::prefix('user')->group(function () {
    Route::post('register', [UserAuthController::class, 'register']);
    Route::post('login', [UserAuthController::class, 'login']);
});

Route::middleware('auth:sanctum')->group(function () {

    Route::get('items', [ItemController::class, 'index2']);


    // Route::get('/users', [Controller::class, 'index']);
    Route::delete('logout', [UserAuthController::class, 'logout']);


    Route::get('/send-email', [EmailController::class, 'send']);


    Route::get('/rides', [RideController::class, 'index']);
    Route::post('get-drivers', [RideController::class, 'getDrivers']);
    Route::post('create-ride', [RideController::class, 'createRide']);
    Route::post('/rides/{rideId}/cancel', [RideController::class, 'cancelRide']);





    Route::get('items/{item}', [ItemController::class, 'show']);

    Route::get('categories', [CategoryController::class, 'index2']);
    Route::get('categories/{category}', [CategoryController::class, 'show']);

    Route::get('stores', [StoreController::class, 'index2']);
    Route::get('stores/{store}', [StoreController::class, 'show']);

    Route::get('/favorites', [FavoriteController::class, 'indx']); // List favorites
    Route::post('/favorites/toggle/{favoritableId}', [FavoriteController::class, 'toggle']); // Add/remove favorite

    Route::get('/cart', [CartController::class, 'index']);
    Route::put('/cart', [CartController::class, 'update']);
    Route::delete('/cart/{itemId}', [CartController::class, 'delete']);


    // Fetch all orders for the authenticated user
    Route::get('/orders', [OrderController::class, 'index']);

    // Create a new order from the cart
    Route::post('/orders', [OrderController::class, 'create']);

    Route::delete('/orders/{orderId}/cancel', [OrderController::class, 'cancelOrder']);
    Route::post('/orders/{orderId}/reorder', [OrderController::class, 'reorder']);

    Route::put('/profile', [UserAuthController::class, 'updateProfile']);

    // Mark an order as delivered
    // Route::put('/orders/{orderId}/delivered', [OrderController::class, 'markAsDelivered']);
});


Route::get('/users', [Controller::class, 'index']);

Route::post('/forgot-password', [ForgotPasswordController::class, 'passwordResetLink'])
    ->middleware('guest')
    ->name('password.email');

Route::post('/reset-password', [ForgotPasswordController::class, 'newPassword'])
    ->name('password.gg');
