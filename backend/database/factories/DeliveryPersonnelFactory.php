<?php

namespace Database\Factories;

use App\Models\DeliveryPersonnel;
use App\Models\Location;
use App\Models\Vehicle;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\DeliveryPersonnel>
 */
class DeliveryPersonnelFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = DeliveryPersonnel::class;

    public function definition()
    {
        $vehicle = Vehicle::whereIn('type', ['bike', 'motorcycle'])
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
            'license_number' => strtoupper($this->faker->bothify('DLIC###??')),
            'password' => bcrypt('password123'),
            'is_available' => $this->faker->boolean(),
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
