<?php

namespace App\Repositories;

use App\Models\Location;

class LocationRepository
{
    public function createLocation(array $data)
    {
        return Location::create([
            'address' => $data['address'],
            'latitude' => $data['lat'],
            'longitude' => $data['long'],
        ]);
    }
}
