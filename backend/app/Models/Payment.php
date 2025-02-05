<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'delivery_id',
        'ride_id',
        'amount',
        'payment_method',
        'status',
    ];

    // Payment belongs to a user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Payment can belong to a delivery
    public function delivery()
    {
        return $this->belongsTo(Delivery::class);
    }

    // Payment can belong to a ride
    public function ride()
    {
        return $this->belongsTo(Ride::class);
    }
}
