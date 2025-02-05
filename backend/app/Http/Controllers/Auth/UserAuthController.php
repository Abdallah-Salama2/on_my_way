<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\UpdateUserProfileRequest;
use App\Http\Requests\UserRegisterRequest;
use App\Services\UserAuthService;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;

class UserAuthController extends Controller
{

    use HttpResponses;

    protected $userAuthService;

    public function __construct(UserAuthService $userAuthService)
    {
        $this->userAuthService = $userAuthService;
    }

    public function register(UserRegisterRequest $request): JsonResponse
    {
        try {
            $validated = $request->validated();
            $user = $this->userAuthService->registerUser($validated);

            $token = $this->userAuthService->createToken($user);

            return $this->success('User registered successfully!', [
                'token' => $token,
                'type' => 'client',
                'user' => $user->load('location'),
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to register user.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $request->authenticate();
        $user = $request->user();
        $remember = $request->has('remember') && $request->remember == 'true';

        $token = $this->userAuthService->createToken($user, $remember);

        return $this->success('You Logged In', [
            'token' => $token,
            'user' => $user->load('location'),
            'type' => 'client',
            'remember' => $remember, // For client-side debugging
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'No authenticated user found.',
            ], 401);
        }

        $this->userAuthService->logoutUser($user);

        return response()->json([
            'message' => 'Successfully logged out',
        ]);
    }

    public function updateProfile(UpdateUserProfileRequest $request): JsonResponse
    {
        try {
            // Get the authenticated user
            $user = $request->user();

            // Validate incoming request data
            $validatedData = $request->validated();

            // Update user-specific fields
            $user->update([
                'name' => $validatedData['name'] ?? $user->name,
                'email' => $validatedData['email'] ?? $user->email,
                'phone' => $validatedData['phone'] ?? $user->phone,
                'password' => isset($validatedData['password']) ? Hash::make($validatedData['password']) : $user->password,
                'ratings' => $validatedData['ratings'] ?? $user->ratings,
            ]);

            // Check if location data is provided and update it
            if (isset($validatedData['address']) || isset($validatedData['latitude']) || isset($validatedData['longitude'])) {
                $user->location->update([
                    'address' => $validatedData['address'] ?? $user->location->address,
                    'latitude' => $validatedData['latitude'] ?? $user->location->latitude,
                    'longitude' => $validatedData['longitude'] ?? $user->location->longitude,
                ]);
            }

            // Return success response
            return response()->json([
                'message' => 'Profile updated successfully!',
                'data' => [
                    'user' => $user->load('location'),
                ],
            ], 200);
        } catch (\Exception $e) {
            // Handle errors and return response
            return response()->json([
                'message' => 'Failed to update profile.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
