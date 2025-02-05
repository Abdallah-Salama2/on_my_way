<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use App\Models\DeliveryPersonnel;
use App\Models\Driver;
use App\Models\Vehicle;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run()
    {
        $this->call([
            LocationSeeder::class,
            VehicleSeeder::class,
            TypeSeeder::class,
            StoreSeeder::class,
            CategorySeeder::class,
            ItemSeeder::class,

        ]);


        $this->call([]);
    }
}
