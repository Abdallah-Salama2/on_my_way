<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'item_id', 'quantity', 'total_price'];

    // Cast total_price to float
    protected $casts = [
        'total_price' => 'float',
    ];

    /**
     * Get the user that owns the cart.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the item associated with the cart.
     */
    public function item()
    {
        return $this->belongsTo(Item::class);
    }
}
