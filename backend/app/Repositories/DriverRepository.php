<?php

namespace App\Repositories;

use App\Models\Driver;

class DriverRepository
{
    public function findAvailableDriversByType($rideType)
    {
        return Driver::where('is_available', 1)
            ->whereHas('vehicle', function ($query) use ($rideType) {
                $query->where('type', $rideType);
            })
            ->with(['location', 'vehicle'])
            ->get();
    }

    public function calculateDriverDetails($drivers, $pickUp, $rideDistance)
    {
        return $drivers->map(function ($driver) use ($pickUp, $rideDistance) {
            $driverDistance = $this->haversine(
                $pickUp['lat'],
                $pickUp['long'],
                $driver->location->latitude,
                $driver->location->longitude
            );

            return [
                'driver' => $driver,
                'distance' => $driverDistance,
                'price' => $this->calculatePrice($driverDistance, $rideDistance),
                'driver_rating' => 5, // Placeholder value
            ];
        });
    }

    public function setDriverAvailability($driverId, $isAvailable)
    {
        Driver::find($driverId)->update(['is_available' => $isAvailable]);
    }

    private function haversine($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371;
        $latDelta = deg2rad($lat2 - $lat1);
        $lonDelta = deg2rad($lon2 - $lon1);

        $a = sin($latDelta / 2) ** 2 +
            cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
            sin($lonDelta / 2) ** 2;

        return $earthRadius * (2 * atan2(sqrt($a), sqrt(1 - $a)));
    }

    private function calculatePrice($driverDistance, $rideDistance)
    {
        $baseFare = 5;
        $perKmRate = 2;
        $driverDistanceFactor = 0.5;
        $surgeMultiplier = 1.2;

        // Limit driver distance impact (e.g., max 10 km contribution)
        $driverDistance = min($driverDistance, 10);

        // Calculate price
        $price = ($baseFare + ($rideDistance * $perKmRate) + ($driverDistance * $driverDistanceFactor)) * $surgeMultiplier;

        // Apply a max fare cap (e.g., $100)
        return round(min($price, 100), 2);
    }


    public function findDriverById($driverId)
    {
        return Driver::find($driverId);
    }
}
