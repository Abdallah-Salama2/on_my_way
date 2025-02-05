<?php

namespace Database\Factories;

use App\Models\Driver;
use App\Models\Location;
use App\Models\Vehicle;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Driver>
 */
class DriverFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Driver::class;

    public function definition()
    {
        // Fetch a vehicle ID that has NOT been assigned
        $vehicle = Vehicle::whereNotIn('type', ['bike'])
            ->whereDoesntHave('driver')
            ->whereDoesntHave('personnel')
            ->inRandomOrder()
            ->first();
        $location = Location::whereDoesntHave('store')
            ->whereDoesntHave('driver')
            ->whereDoesntHave('delivery_personnel')
            ->inRandomOrder()
            ->first();
        return [
            'location_id' => $location->id,
            'vehicle_id' => $vehicle ? $vehicle->id : Vehicle::factory()->create()->id,
            'name' => $this->faker->name(),
            'email' => $this->faker->unique()->safeEmail(),
            'phone' => $this->faker->phoneNumber(),
            'license_number' => strtoupper($this->faker->bothify('LIC###??')),
            'password' => bcrypt('123456789'),
            'is_available' => $this->faker->boolean(),
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
