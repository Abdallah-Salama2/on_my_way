<?php

namespace App\Http\Controllers;

use App\Services\RideService;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class RideController extends Controller
{
    use HttpResponses;

    protected $rideService;

    public function __construct(RideService $rideService)
    {
        $this->rideService = $rideService;
    }

    /**
     * Get the nearest drivers with calculated distances and prices.
     */
    public function getDrivers(Request $request)
    {
        $request->validate([
            'pickUp.address' => 'required|string',
            'pickUp.lat' => 'required|numeric|between:-90,90',
            'pickUp.long' => 'required|numeric|between:-180,180',
            'rideType' => 'required|string',
            'distance' => 'required|numeric|min:0',
        ]);

        try {
            $data = $request->only(['pickUp', 'dropOff', 'rideType', 'distance']);
            $drivers = $this->rideService->getNearestDrivers($data);

            return $this->success('Nearest Drivers To you', $drivers);
        } catch (\Exception $e) {
            return $this->failure('An error occurred while processing your request.', [
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Create a new ride.
     */
    public function createRide(Request $request)
    {
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

        try {
            $ride = $this->rideService->createRide($request->all());

            return $this->success('Ride created successfully.', $ride);
        } catch (\Exception $e) {
            return $this->failure('An error occurred while creating the ride.', [
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Cancel a ride by ID.
     */
    public function cancelRide($rideId)
    {
        try {
            $ride = $this->rideService->cancelRide($rideId);

            return $this->success('Ride canceled successfully.', $ride);
        } catch (\Exception $e) {
            return $this->failure('An error occurred while canceling the ride.', [
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}
