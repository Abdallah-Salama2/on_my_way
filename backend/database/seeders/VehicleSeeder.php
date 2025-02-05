<?php

namespace Database\Seeders;

use App\Models\DeliveryPersonnel;
use App\Models\Driver;
use App\Models\Vehicle;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class VehicleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //

        // Step 1: Create 5 'bike' or 'motorcycle' vehicles for Delivery Personnel
        $deliveryVehicles = Vehicle::factory()
            ->count(10)
            ->state(function () {
                return ['type' => fake()->randomElement(['bike', 'motorcycle'])];
            })
            ->create();

        // Step 2: Create 5 'car' or 'van' vehicles for Drivers
        $driverVehicles = Vehicle::factory()
            ->count(10)
            ->state(function () {
                return ['type' => fake()->randomElement(['car', 'motorcycle'])];
            })
            ->create();

        // Step 3: Assign the vehicles to Delivery Personnel
        foreach ($deliveryVehicles as $vehicle) {
            DeliveryPersonnel::factory()->create(['vehicle_id' => $vehicle->id]);
        }

        // Step 4: Assign the vehicles to Drivers
        foreach ($driverVehicles as $vehicle) {
            Driver::factory()->create(['vehicle_id' => $vehicle->id]);
        }
    }
}
