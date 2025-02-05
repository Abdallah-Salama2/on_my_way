<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class CategorySeeder extends Seeder
{
    public function run()
    {
        // Truncate the table (disable foreign key checks if necessary)
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        DB::table('categories')->truncate();
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        // Unsplash API Key
        $unsplashKeys = [
            'sVbvsgEXq0xG5tCVxeILdmT_jYjldz_I_nbCR9nJIOc',
        ];
        $currentKeyIndex = 0;

        // Helper function to get image from Unsplash
        $getUnsplashImage = function ($itemName) use ($unsplashKeys, $currentKeyIndex) {
            $response = Http::withOptions(['verify' => false])
                ->get('https://api.unsplash.com/search/photos', [
                    'client_id' => $unsplashKeys[$currentKeyIndex],
                    'query' => $itemName,
                    'per_page' => 1,
                ]);

            $data = $response->json();
            return $data['results'][0]['urls']['regular'] ?? null;
        };

        // Restaurant Categories
        $restaurantCategories = [
            ['name' => 'Italian', 'description' => 'Authentic Italian cuisine and dishes.'],
            ['name' => 'Chinese', 'description' => 'Traditional and modern Chinese food.'],
            ['name' => 'Indian', 'description' => 'Spices and flavors of Indian cuisine.'],
            ['name' => 'Mexican', 'description' => 'Bold flavors of Mexican dishes.'],
            ['name' => 'Japanese', 'description' => 'Sushi, ramen, and other Japanese delicacies.'],
            ['name' => 'Thai', 'description' => 'Exquisite Thai food with aromatic spices.'],
            ['name' => 'Mediterranean', 'description' => 'Healthy and vibrant Mediterranean dishes.'],
            ['name' => 'American', 'description' => 'Classic American fast food and more.'],
            ['name' => 'French', 'description' => 'Elegant French cuisine and pastries.'],
            ['name' => 'Korean', 'description' => 'Korean BBQ and traditional flavors.'],
            ['name' => 'Seafood', 'description' => 'Fresh seafood specialties.'],
            ['name' => 'Vegetarian', 'description' => 'Vegetarian-friendly dining options.'],
            ['name' => 'Vegan', 'description' => 'Delicious vegan dishes and meals.'],
            ['name' => 'Fast Food', 'description' => 'Quick and convenient fast food.'],
            ['name' => 'BBQ & Grill', 'description' => 'Barbecue and grilled dishes.'],
        ];

        // Supermarket Categories
        $supermarketCategories = [
            ['name' => 'Fresh Produce', 'description' => 'Fruits and vegetables, fresh and organic.'],
            ['name' => 'Dairy', 'description' => 'Milk, cheese, yogurt, and more.'],
            ['name' => 'Meat & Poultry', 'description' => 'Fresh and frozen meat and poultry.'],
            ['name' => 'Bakery', 'description' => 'Freshly baked bread, cakes, and pastries.'],
            ['name' => 'Frozen Foods', 'description' => 'Convenient frozen meals and snacks.'],
            ['name' => 'Snacks', 'description' => 'Chips, cookies, and other snacks.'],
            ['name' => 'Beverages', 'description' => 'Juices, sodas, and other drinks.'],
            ['name' => 'Cleaning Supplies', 'description' => 'Household cleaning products.'],
            ['name' => 'Health & Beauty', 'description' => 'Personal care and beauty products.'],
            ['name' => 'Canned Goods', 'description' => 'Canned fruits, vegetables, and soups.'],
            ['name' => 'Pasta & Grains', 'description' => 'Rice, pasta, and other grains.'],
            ['name' => 'Condiments & Spices', 'description' => 'Sauces, spices, and seasonings.'],
            ['name' => 'Breakfast Foods', 'description' => 'Cereal, oatmeal, and breakfast items.'],
            ['name' => 'Baby Products', 'description' => 'Baby food, diapers, and essentials.'],
        ];

        // Add 'type' to each category
        foreach ($restaurantCategories as &$category) {
            $category['type_id'] = 1;
        }
        unset($category); // Unset reference after loop

        foreach ($supermarketCategories as &$category) {
            $category['type_id'] = 2;
        }
        unset($category); // Unset reference after loop

        // Merge categories
        $categories = array_merge($restaurantCategories, $supermarketCategories);

        // Add image_url for each category
        foreach ($categories as &$category) {
            $image = $getUnsplashImage($category['name']);
            $category['image_url'] = $image ?: 'https://example.com/default-image.jpg'; // Replace with your default image URL
        }
        unset($category); // Unset reference after loop

        // Insert categories into the database
        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
