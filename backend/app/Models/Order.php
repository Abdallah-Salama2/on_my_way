<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'store_id',
        'delivery_id',
        'order_amount',
        'order_time',
        'status',
    ];

    // Relationship: Order belongs to a user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Relationship: Order belongs to a store
    public function store()
    {
        return $this->belongsTo(Store::class);
    }

    // Relationship: Order belongs to a delivery
    public function delivery()
    {
        return $this->belongsTo(Delivery::class);
    }

    // Relationship: Order has many order items
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
}
