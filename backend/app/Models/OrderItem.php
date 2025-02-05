<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    use HasFactory;
    protected $fillable = [
        'order_id',
        'item_id',
        'quantity',
        'price',
    ];

    // Relationship: OrderItem belongs to an Order
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    // Relationship: OrderItem belongs to an Item
    public function item()
    {
        return $this->belongsTo(Item::class);
    }
}
