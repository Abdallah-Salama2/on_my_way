<?php

namespace App\Services;

use App\Models\Location;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Auth\Events\Registered;

class UserAuthService
{
    public function registerUser(array $validated)
    {
        DB::beginTransaction();

        try {
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

            event(new Registered($user));
            Auth::login($user);

            DB::commit();

            return $user;
        } catch (\Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }

    public function createToken($user, $remember = false)
    {
        return $user->createToken('api-token', ['*'], $remember ? now()->addMonths(1) : now()->addHours(2))->plainTextToken;
    }

    public function logoutUser($user)
    {
        $user->currentAccessToken()->delete();
    }
}
