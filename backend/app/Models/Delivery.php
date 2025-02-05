<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Delivery extends Model
{
    use HasFactory;

    protected $fillable = [
        'delivery_personnel_id',
        'pickup_location',
        'dropoff_location',
        'fare',
        'delivery_time',
        'status',
    ];

    // Delivery belongs to delivery personnel
    public function order()
    {
        return $this->hasMany(Order::class);
    }

    // Delivery belongs to delivery personnel
    public function deliveryPersonnel()
    {
        return $this->belongsTo(DeliveryPersonnel::class);
    }
    // Relationship with Pickup Location
    public function pickupDeliveryLocation(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'pickup_location_id');
    }

    // Relationship with Drop-off Location
    public function dropOffDeliveryLocation(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'drop_off_location_id');
    }
}
