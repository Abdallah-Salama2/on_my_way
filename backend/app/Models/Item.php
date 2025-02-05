<?php

namespace App\Models;

use App\Http\traits\FavoriteScope as TraitsFavoriteScope;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Item extends Model
{
    use HasFactory;
    use TraitsFavoriteScope;

    protected $fillable = [
        'store_id',
        'category_id',
        'name',
        'image_url',
        'description',
        'price',
        'rating',
    ];


    // Cast price to float
    protected $casts = [
        'price' => 'float',
    ];

    // Relationship: Item belongs to a store
    public function store()
    {
        return $this->belongsTo(Store::class);
    }

    // Relationship: Item is part of many order items
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function favorites()
    {
        return $this->morphMany(Favorite::class, 'favoritable');
    }

    public function carts()
    {
        return $this->hasMany(Cart::class);
    }
}
