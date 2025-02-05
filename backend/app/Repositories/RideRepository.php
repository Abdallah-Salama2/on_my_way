<?php

namespace App\Repositories;

use App\Models\Ride;

class RideRepository
{

    public function getUserRides($userId)
    {
        $rides = Ride::where('user_id', $userId)->where('status', "!=", "canceled")
            ->with([
                'pickupRideLocation', // Load relationships
                'dropOffRideLocation',
            ])
            ->get();

        return $rides;
    }
    public function createRide(array $data)
    {
        return Ride::create($data);
    }

    public function findRideById($rideId)
    {
        return Ride::findOrFail($rideId);
    }

    public function updateRideStatus($ride, $status)
    {
        // dd($ride);
        $ride->update(['status' => $status, 'driver_id' => null]);
    }
}
