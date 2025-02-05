<?php

namespace Database\Factories;

use App\Models\Location;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Location>
 */
class LocationFactory extends Factory
{
    protected $model = Location::class;

    public function definition()
    {
        // Central coordinates (e.g., central point of a city)
        $centralLatitude = 30.059407; // Example: New York City's latitude
        $centralLongitude = 31.223722; // Example: New York City's longitude

        // Generate small random offsets for nearby locations
        $offsetLatitude = $this->faker->randomFloat(6, -0.045, 0.045); // ~5 km
        $offsetLongitude = $this->faker->randomFloat(6, -0.045, 0.045); // ~5 km

        return [
            'address' => $this->faker->address(),
            'latitude' => $centralLatitude + $offsetLatitude,
            'longitude' => $centralLongitude + $offsetLongitude,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
