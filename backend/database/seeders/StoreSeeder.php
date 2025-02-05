<?php

namespace Database\Seeders;

use App\Models\Store;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class StoreSeeder extends Seeder
{
    public function run()
    {
        // Truncate the stores table
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        DB::table('stores')->truncate();
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        // Unsplash API Key
        $unsplashKeys = [
            'sVbvsgEXq0xG5tCVxeILdmT_jYjldz_I_nbCR9nJIOc',
        ];
        $currentKeyIndex = 0;

        // Helper function to fetch Unsplash image
        $getUnsplashImage = function ($query) use ($unsplashKeys, $currentKeyIndex) {
            $response = Http::withOptions(['verify' => false])
                ->get('https://api.unsplash.com/search/photos', [
                    'client_id' => $unsplashKeys[$currentKeyIndex],
                    'query' => $query,
                    'per_page' => 1,
                ]);

            $data = $response->json();
            return $data['results'][0]['urls']['regular'] ?? null;
        };

        // Create Restaurants
        $restaurants = Store::factory()
            ->count(5)
            ->restaurant()
            ->make();

        foreach ($restaurants as $restaurant) {
            $restaurant->image_url = $getUnsplashImage('restaurant') ?: 'https://example.com/default-restaurant.jpg';
            $restaurant->save();
        }

        // Create Supermarkets
        $supermarkets = Store::factory()
            ->count(5)
            ->supermarket()
            ->make();

        foreach ($supermarkets as $supermarket) {
            $supermarket->image_url = $getUnsplashImage('supermarket') ?: 'https://example.com/default-supermarket.jpg';
            $supermarket->save();
        }
    }
}
