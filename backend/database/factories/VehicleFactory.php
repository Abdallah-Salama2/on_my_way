<?php

namespace Database\Factories;

use App\Models\Vehicle;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Vehicle>
 */
class VehicleFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Vehicle::class;

    public function definition()
    {
        $type = $this->faker->randomElement(['Car', 'Motorcycle', 'Bike']);

        return [
            'image_url' => $this->faker->imageUrl(640, 480, 'vehicles'),
            'type' => $type,
            'model' => $this->faker->word(),
            'color' => $this->faker->safeColorName(),
            'registration_number' => strtoupper($this->faker->bothify('REG###??')),
            'capacity' => in_array($type, ['Motorcycle', 'Bike'])
                            ? $this->faker->numberBetween(1, 2)
                            : $this->faker->numberBetween(2, 8),
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

}
