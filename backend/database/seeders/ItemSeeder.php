<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Item;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class ItemSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {

        // // Truncate the table (disable foreign key checks if necessary)
        // DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        // DB::table('items')->truncate();
        // DB::statement('SET FOREIGN_KEY_CHECKS=1;');


        // Define food items for each category
        $foodItems = [
            'Italian' => ['name' => 'Pizza Express Margherita', 'Lasagna', 'Risotto', 'Spaghetti alla Carbonara', 'Trifle'],
            'Chinese' => ['Kung Pao Chicken', 'Dumplings', 'Sweet and Sour Pork', 'Chicken Congee', 'Szechuan Beef'],
            'Indian' => ['Nutty Chicken Curry', 'Biryani', 'Matar Paneer', 'Lamb Biryani', 'Tandoori Chicken'],
            'Mexican' => ['Tacos', 'Braised Beef Chilli', 'Chickpea Fajitas', 'Crock Pot Chicken Baked Tacos', 'Stuffed Bell Peppers with Quinoa and Black Beans'],
            'Japanese' => ['Sushi', 'Honey Teriyaki Salmon', 'Japanese gohan rice', 'Tonkatsu pork', 'Teriyaki Chicken'],
            'Thai' => ['Massaman Beef curry', 'Green Curry', 'Pad See Ew'],
            'Mediterranean' => ['Mulukhiyah', 'Shakshuka', 'Moussaka', 'Paella', 'Tuna and Egg Briks'],
            'American' => ['Burger', 'Fried Chicken', 'Banana Pancakes', 'Lasagna Sandwiches', 'Fruit and Cream Cheese Breakfast Pastries'],
            'French' => ['Croissant', 'Boulangère Potatoes', 'Coq au Vin', 'Ratatouille', 'Provençal Omelette Cake'],
            'Seafood' => ['Fish Stew with Rouille', 'Fish Pie', 'Portuguese Fish Stew', 'Fish Fofos', 'Three Fish Pie'],
            'Vegetarian' => ['Vegan Lasagna', 'Ratatouille', 'Roast fennel and aubergine paella', 'Vegan Chocolate Cake', 'Egg Drop Soup'],
            'Fast Food' => ['Beef and Mustard Pie', 'Breakfast Potatoes', 'Full English Breakfast', 'Chivito uruguayo', 'Big Mac'],


            // Supermarket Categories
            'Fresh Produce' => ['Apples', 'Bananas', 'Carrots', 'Lettuce', 'Tomatoes'],
            'Dairy' => ['Milk', 'Cheese', 'Yogurt', 'Butter', 'Cream'],
            'Meat & Poultry' => ['Chicken Breast', 'Ground Beef', 'Pork Chops', 'Lamb Ribs', 'Turkey'],
            'Bakery' => ['Bread', 'Croissants', 'Bagels', 'Muffins', 'Cakes'],
            'Frozen Foods' => ['Frozen Pizza', 'Ice Cream', 'Frozen Vegetables', 'Frozen Meals', 'Frozen Fish'],
            'Snacks' => ['Chips', 'Cookies', 'Pretzels', 'Popcorn', 'Granola Bars'],
            'Beverages' => ['Orange Juice', 'Soda', 'Coffee', 'Tea', 'Mineral Water'],
            'Cleaning Supplies' => ['Laundry Detergent', 'Dish Soap', 'All-Purpose Cleaner', 'Bleach', 'Sponges'],
            'Health & Beauty' => ['Shampoo', 'Toothpaste', 'Body Lotion', 'Deodorant', 'Lip Balm'],
            'Canned Goods' => ['Canned Tomatoes', 'Canned Beans', 'Canned Tuna', 'Canned Corn', 'Canned Soup'],
            'Pasta & Grains' => ['Spaghetti', 'Rice', 'Quinoa', 'Penne', 'Couscous'],
            'Condiments & Spices' => ['Ketchup', 'Mayonnaise', 'Salt', 'Pepper', 'Curry Powder'],
            'Breakfast Foods' => ['Cereal', 'Oatmeal', 'Pancake Mix', 'Eggs', 'Bagels'],
            'Baby Products' => ['Baby Food', 'Diapers', 'Baby Wipes', 'Formula', 'Baby Shampoo'],
        ];


        // Unsplash API keys
        $unsplashKeys = [
            'sVbvsgEXq0xG5tCVxeILdmT_jYjldz_I_nbCR9nJIOc',
            'aGBpgLhWmGHzJnoKdoL2CLiEXCD19MCARo4l34egf8w'
        ];
        $currentKeyIndex = 0;

        // Fetch all categories
        $categories = Category::all();

        foreach ($categories as $category) {
            $items = $foodItems[$category->name] ?? ['Generic Item'];

            foreach ($items as $itemName) {
                $storeIdRange = $category->type_id == 1 ? [1, 5] : [6, 10];
                $imageUrl = null;

                if ($category->type_id == 1) {
                    // Fetch from TheMealDB
                    $response = Http::withOptions(['verify' => false])
                        ->get('https://www.themealdb.com/api/json/v1/1/search.php?s=' . urlencode($itemName));

                    if ($response->successful() && isset($response['meals'][0]['strMealThumb'])) {
                        $imageUrl = $response['meals'][0]['strMealThumb'];
                    }
                } elseif ($category->type_id == 2) {
                    // Fetch from Unsplash
                    for ($i = 0; $i < count($unsplashKeys); $i++) {
                        $unsplashResponse = Http::withOptions(['verify' => false])
                            ->get('https://api.unsplash.com/search/photos', [
                                'client_id' => $unsplashKeys[$currentKeyIndex],
                                'query' => $itemName,
                                'per_page' => 1,
                            ]);

                        if ($unsplashResponse->successful() && isset($unsplashResponse['results'][0]['urls']['regular'])) {
                            $imageUrl = $unsplashResponse['results'][0]['urls']['regular'];
                            break; // Break the loop on successful fetch
                        }

                        // Rotate to the next API key
                        $currentKeyIndex = ($currentKeyIndex + 1) % count($unsplashKeys);
                    }
                }

                if (!$imageUrl) {
                    // Final fallback image
                    $imageUrl = 'https://via.placeholder.com/640x480.png?text=No+Image';
                }

                // Create the item
                Item::create([
                    'store_id' => fake()->numberBetween($storeIdRange[0], $storeIdRange[1]),
                    'category_id' => $category->id,
                    'name' => $itemName,
                    'image_url' => $imageUrl,
                    'description' => 'Delicious ' . $itemName,
                    'price' => fake()->randomFloat(2, 5, 50),
                    'rating' => fake()->randomFloat(1, 3, 5),
                ]);
            }
        }
    }
}
