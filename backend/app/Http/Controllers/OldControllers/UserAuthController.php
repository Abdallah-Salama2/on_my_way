<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\UserRegisterRequest;
use App\Models\Location;
use App\Models\User;
use App\Notifications\LoginNotification;
use App\Traits\HttpResponses;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class UserAuthController extends Controller
{
    //
    use HttpResponses;

    public function register(UserRegisterRequest $request): JsonResponse
    {
        try {
            DB::beginTransaction(); // Start a database transaction

            $validated = $request->validated();

            $location = Location::create([
                'address' => $validated['address'],
                'latitude' => $validated['latitude'] ?? null,
                'longitude' => $validated['longitude'] ?? null,
            ]);

            $user = User::create([
                'location_id' => $location->id,
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
                'phone' => $validated['phone'],
                'ratings' => $validated['ratings'] ?? null,
            ]);

            event(new Registered($user)); // Trigger user registered event

            Auth::login($user); // Log the user in

            $token = $user->createToken('api-token')->plainTextToken;

            DB::commit(); // Commit the transaction
            // dd($user);
            return $this->success('User registered successfully!', [
                'token' => $token,
                'type' => 'client',
                'user' => $user->load('location'),
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack(); // Rollback the transaction on error

            // Log the exception for debugging
            \Log::error('User Registration Failed: ' . $e->getMessage());

            return $this->failure('Failed to register user.', [
                'error' => 'An unexpected error occurred.',
            ], 500);
        }
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $request->authenticate();

        $user = $request->user();
        // Check if "remember me" was requested
        $remember = $request->has('remember') && $request->remember == 'true';

        // Create a token with a longer expiration if "remember me" is enabled
        $token = $user->createToken('api-token', ['*'], $remember ? now()->addMonths(1) : now()->addHours(2));

        return $this->success('You Logged In', [
            'token' => $token->plainTextToken,
            'user' => $user->load('location'),
            'type' => 'client',
            'remember' => $remember, // For client-side debugging
        ]);
    }

    public function logout(Request $request): JsonResponse
    {

        try {
            $user = $request->user();

            if (!$user) {
                return $this->failure('No authenticated user found.', null, 401);
            }

            $user->currentAccessToken()->delete();

            return $this->success('Successfully logged out');
        } catch (\Exception $e) {
            return $this->failure('Failed to log out.', [
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
