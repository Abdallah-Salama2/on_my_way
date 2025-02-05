<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Ride extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'driver_id',
        'pickup_location_id',
        'drop_off_location_id',
        'fare',
        'status',
        'start_time',
        'end_time',
    ];

    // Ride belongs to a user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Ride belongs to a driver
    public function driver()
    {
        return $this->belongsTo(Driver::class);
    }

    // Relationship with Pickup Location
    public function pickupRideLocation(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'pickup_location_id');
    }

    // Relationship with Drop-off Location
    public function dropOffRideLocation(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'drop_off_location_id');
    }
}
