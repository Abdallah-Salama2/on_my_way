<?php

namespace App\Http\Controllers;

use App\Jobs\DeleteStaleRide;
use App\Models\Driver;
use App\Models\Location;
use App\Models\Ride;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RideController extends Controller
{
    use HttpResponses;

    /**
     * Get the nearest drivers with calculated distances and prices.
     */
    public function getDrivers(Request $request)
    {
        // Validate the incoming request
        $request->validate([
            'pickUp.address' => 'required|string',
            'pickUp.lat' => 'required|numeric|between:-90,90',
            'pickUp.long' => 'required|numeric|between:-180,180',
            'rideType' => 'required|string',
            'distance' => 'required|numeric|min:0',
        ]);

        try {
            // Extract input data
            $pickUp = $request->input('pickUp');
            $dropOff = $request->input('dropOff');
            $rideType = $request->input('rideType');
            $rideDistance = $request->input('distance');

            // Get available drivers matching the ride type
            $drivers = $this->getAvailableDrivers($rideType);

            // Filter drivers with valid locations and calculate distance/price
            $driversWithDetails = $this->getDriversWithDetails($drivers, $pickUp['lat'], $pickUp['long'], $rideDistance);

            // dd($driversWithDetails);
            // Select the nearest two drivers
            $nearestDrivers = $driversWithDetails->sortBy('distance')->take(2);


            return $this->success('Nearest Drivers To you',  $driversWithDetails->values());
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred while processing your request.',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Retrieve available drivers filtered by vehicle type.
     */
    private function getAvailableDrivers($rideType)
    {
        return Driver::where('is_available', 1)
            ->whereHas('vehicle', function ($query) use ($rideType) {
                $query->where('type', $rideType);
            })
            ->with(['location', 'vehicle'])
            ->get()
            ->map(function ($driver) {
                return [
                    'latitude' => $driver->location->latitude ?? null,
                    'longitude' => $driver->location->longitude ?? null,
                    'driver' => $driver,
                ];
            })
            ->filter(function ($driver) {
                return $driver['latitude'] !== null && $driver['longitude'] !== null;
            });
    }

    /**
     * Enrich drivers with distance, price, and rating information.
     */
    private function getDriversWithDetails($drivers, $pickUpLat, $pickUpLong, $rideDistance)
    {
        return $drivers->map(function ($driver) use ($pickUpLat, $pickUpLong, $rideDistance) {
            $driverDistance = $this->haversine($pickUpLat, $pickUpLong, $driver['latitude'], $driver['longitude']);
            $price = $this->calculatePrice($driverDistance, $rideDistance);

            return array_merge($driver, [
                'distance' => $driverDistance,
                'price' => $price,
                'driver_rating' => 5, // Static value for now
            ]);
        });
    }

    /**
     * Calculate the price of the ride.
     */
    private function calculatePrice($driverDistance, $rideDistance)
    {
        $baseFare = 5; // Base fare for the ride
        $perKmRate = 2; // Rate per kilometer
        $surgeMultiplier = 1.2; // Surge pricing multiplier (if applicable)

        $price = $baseFare + ($rideDistance * $perKmRate) + ($driverDistance * 0.5);
        $price *= $surgeMultiplier;

        return round($price, 2);
    }

    /**
     * Haversine formula to calculate distance between two lat/long points.
     */
    private function haversine($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371; // Radius of Earth in kilometers

        $lat1 = deg2rad($lat1);
        $lon1 = deg2rad($lon1);
        $lat2 = deg2rad($lat2);
        $lon2 = deg2rad($lon2);

        $latDelta = $lat2 - $lat1;
        $lonDelta = $lon2 - $lon1;

        $a = sin($latDelta / 2) ** 2 +
            cos($lat1) * cos($lat2) *
            sin($lonDelta / 2) ** 2;

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }

    /**
     * Create a new ride.
     */
    public function createRide(Request $request)
    {
        // Validate the incoming request
        $request->validate([
            'pickUp.address' => 'required|string',
            'pickUp.lat' => 'required|numeric|between:-90,90',
            'pickUp.long' => 'required|numeric|between:-180,180',
            'dropOff.address' => 'required|string',
            'dropOff.lat' => 'required|numeric|between:-90,90',
            'dropOff.long' => 'required|numeric|between:-180,180',
            'fare' => 'required|numeric|min:0',
            'driverId' => 'required|integer|exists:drivers,id',
        ]);

        $userId = auth()->user()->id;

        DB::beginTransaction();
        try {
            // Extract input data
            $pickUp = $request->input('pickUp');
            $dropOff = $request->input('dropOff');
            $fare = $request->input('fare');
            $driverId = $request->input('driverId');

            $driver = Driver::find($driverId);

            // Create locations for pickup and dropoff
            $pickUpLocation = Location::create([
                'address' => $pickUp['address'],
                'latitude' => $pickUp['lat'],
                'longitude' => $pickUp['long'],
            ]);

            $dropOffLocation = Location::create([
                'address' => $dropOff['address'],
                'latitude' => $dropOff['lat'],
                'longitude' => $dropOff['long'],
            ]);

            $driver->update([
                'is_available' => 0
            ]);
            // Create a ride record
            $ride = Ride::create([
                'pickup_location_id' => $pickUpLocation->id,
                'drop_off_location_id' => $dropOffLocation->id,
                'user_id' => $userId,
                'fare' => $fare,
                'driver_id' => $driverId,
                'status' => 'onRoad',
            ]);

            DB::commit();

            return $this->success('Ride created successfully.', $ride);
        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'error' => 'An error occurred while creating the ride.',
                'message' => $e->getMessage(),
            ], 500);
        }
    }


    /**
     * Cancel a ride by ID.
     *
     * @param int $rideId
     * @return \Illuminate\Http\JsonResponse
     */
    public function cancelRide($rideId)
    {
        DB::beginTransaction();
        try {
            // Retrieve the ride
            $ride = Ride::findOrFail($rideId);
            $driverId = $ride->driver_id;
            $driver = Driver::find($driverId);

            // Check if the user is authorized to cancel the ride
            $userId = auth()->user()->id;
            if ($ride->user_id !== $userId) {
                return response()->json([
                    'error' => 'Unauthorized action.',
                ], 403);
            }

            // Update the ride status to 'canceled'
            $ride->update(['status' => 'canceled', 'driver_id' => null]);
            $driver->update([
                'is_available' => 1
            ]);
            DB::commit();

            return $this->success('Ride canceled successfully.', $ride);
        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'error' => 'An error occurred while canceling the ride.',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}
