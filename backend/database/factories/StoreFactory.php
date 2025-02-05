<?php

namespace Database\Factories;

use App\Models\Location;
use App\Models\Store;
use Illuminate\Database\Eloquent\Factories\Factory;

class StoreFactory extends Factory
{
    protected $model = Store::class;

    public function definition()
    {
        static $usedLocationIds = [];

        // Get a location_id that hasn't been used yet
        $locationId = Location::query()
            ->whereNotIn('id', $usedLocationIds)
            ->inRandomOrder()
            ->value('id');

        // Add the location_id to the used list
        if ($locationId) {
            $usedLocationIds[] = $locationId;
        }

        return [
            'location_id' => $locationId,
            'image_url' => 'https://example.com/default-business.jpg', // Will be overridden in seeder
            'name' => $this->faker->company(),
            'phone' => $this->faker->phoneNumber(),
            'rating' => $this->faker->numberBetween(1, 5),
            'opening_hours' => '09:00 AM - 09:00 PM',
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function restaurant()
    {
        return $this->state(fn(array $attributes) => [
            'name' => $this->faker->company() . ' Restaurant',
            'type_id' => 1,
        ]);
    }

    public function supermarket()
    {
        return $this->state(fn(array $attributes) => [
            'name' => $this->faker->company() . ' Supermarket',
            'type_id' => 2,
        ]);
    }
}
