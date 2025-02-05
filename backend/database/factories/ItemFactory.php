<?php

namespace Database\Factories;

use App\Models\Item;
use App\Models\Store;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Arr;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Item>
 */
class ItemFactory extends Factory
{
    protected $model = Item::class;

    public function definition()
    {
        return [
            'store_id' => Store::factory(),
            'category_id' => null,
            'image_url' => $this->faker->imageUrl(640, 480, 'food'),
            'name' => $this->faker->word(),
            'description' => $this->faker->sentence(),
            'price' => $this->faker->randomFloat(2, 1, 100),
            'rating' => $this->faker->numberBetween(1, 5),
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function mealsOrDishes()
    {
        $mealNames = [
            'Pizza Margherita',
            'Grilled Chicken',
            'Pasta Alfredo',
            'Beef Burger',
            'Caesar Salad',
            'Tacos',
            'Sushi Roll',
            'Tom Yum Soup',
            'BBQ Ribs',
            'Steak',
        ];

        // Unique meal names for the same store
        static $usedMeals = [];

        return $this->state(function (array $attributes) use ($mealNames, &$usedMeals) {
            // Find a meal that hasn't been used yet for this store
            $remainingMeals = array_diff($mealNames, $usedMeals);

            if (empty($remainingMeals)) {
                $usedMeals = []; // Reset for the next store
                $remainingMeals = $mealNames;
            }

            $meal = Arr::random($remainingMeals);
            $usedMeals[] = $meal;

            return [
                'name' => $meal,
            ];
        });
    }

    public function supermarketProducts()
    {
        $supermarketProducts = [
            'Fruits' => ['Apple', 'Banana', 'Orange', 'Strawberry'],
            'Vegetables' => ['Carrot', 'Broccoli', 'Spinach', 'Potato'],
            'Meats' => ['Chicken Breast', 'Beef Steak', 'Salmon Fillet'],
            'Dairy' => ['Milk', 'Cheese', 'Yogurt'],
            'Pantry' => ['Rice', 'Pasta', 'Bread'],
            'Beverages' => ['Orange Juice', 'Coffee', 'Tea'],
            'Snacks' => ['Potato Chips', 'Cookies', 'Chocolate Bar'],
        ];

        static $usedProducts = [];

        return $this->state(function (array $attributes) use ($supermarketProducts, &$usedProducts) {
            $flattenedProducts = Arr::flatten($supermarketProducts);
            $remainingProducts = array_diff($flattenedProducts, $usedProducts);

            if (empty($remainingProducts)) {
                $usedProducts = []; // Reset for the next store
                $remainingProducts = $flattenedProducts;
            }

            $product = Arr::random($remainingProducts);
            $usedProducts[] = $product;

            return [
                'name' => $product,
            ];
        });
    }
}
