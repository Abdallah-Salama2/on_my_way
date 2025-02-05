<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Location extends Model
{
    use HasFactory;

    protected $fillable = [
        'address',
        'latitude',
        'longitude',
    ];

    public function user()
    {
        return $this->hasOne(User::class, 'location_id', 'id');
    }

    public function store()
    {
        return $this->hasOne(Store::class);
    }

    public function driver()
    {
        return $this->hasOne(Driver::class);
    }

    public function delivery_personnel()
    {
        return $this->hasOne(DeliveryPersonnel::class);
    }

    public function pickupDeliveries(): HasMany
    {
        return $this->hasMany(Delivery::class, 'pickup_location_id');
    }

    public function dropOffDeliveries(): HasMany
    {
        return $this->hasMany(Delivery::class, 'drop_off_location_id');
    }
    public function pickupRides(): HasMany
    {
        return $this->hasMany(Ride::class, 'pickup_location_id');
    }

    // Relationship with Drop-off Location
    public function dropOffRides(): HasMany
    {
        return $this->hasMany(Ride::class, 'drop_off_location_id');
    }
}
