<?php

namespace App\Services;

use App\Repositories\DriverRepository;
use App\Repositories\RideRepository;
use App\Repositories\LocationRepository;
use Illuminate\Support\Facades\DB;

class RideService
{
    protected $driverRepository;
    protected $rideRepository;
    protected $locationRepository;

    public function __construct(
        DriverRepository $driverRepository,
        RideRepository $rideRepository,
        LocationRepository $locationRepository
    ) {
        $this->driverRepository = $driverRepository;
        $this->rideRepository = $rideRepository;
        $this->locationRepository = $locationRepository;
    }

    public function getUserRides($userId)
    {
        return $this->rideRepository->getUserRides($userId);
    }

    public function getNearestDrivers(array $data)
    {
        $pickUp = $data['pickUp'];
        $rideType = $data['rideType'];
        $rideDistance = $data['distance'];

        $drivers = $this->driverRepository->findAvailableDriversByType($rideType);
        return $this->driverRepository->calculateDriverDetails($drivers, $pickUp, $rideDistance);
    }

    public function createRide(array $data)
    {
        DB::beginTransaction();

        try {
            $pickUpLocation = $this->locationRepository->createLocation($data['pickUp']);
            $dropOffLocation = $this->locationRepository->createLocation($data['dropOff']);

            $this->driverRepository->setDriverAvailability($data['driverId'], 0);

            $ride = $this->rideRepository->createRide([
                'pickup_location_id' => $pickUpLocation->id,
                'drop_off_location_id' => $dropOffLocation->id,
                'user_id' => auth()->id(),
                'fare' => $data['fare'],
                'driver_id' => $data['driverId'],
                'status' => 'onRoad',
            ]);

            DB::commit();

            return $ride;
        } catch (\Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }

    public function cancelRide($rideId)
    {

        try {
            // Retrieve the ride
            $ride = $this->rideRepository->findRideById($rideId);

            // Check if the user is authorized to cancel the ride
            if ($ride->user_id !== auth()->id()) {
                throw new \Exception('Unauthorized action.', 403);
            }



            // Retrieve the associated driver
            if ($ride->driver_id) {
                $driver = $this->driverRepository->findDriverById($ride->driver_id);

                // Check if the driver exists before updating
                if ($driver) {
                    $this->driverRepository->setDriverAvailability($ride->driver_id, 1);
                }
            }
            // Update the ride status to 'canceled'
            $this->rideRepository->updateRideStatus($ride, 'canceled');


            return $ride;
        } catch (\Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }
}
