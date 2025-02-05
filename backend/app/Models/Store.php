<?php

namespace App\Models;

use App\Http\traits\FavoriteScope;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Store extends Model
{
    use HasFactory;
    use FavoriteScope;
    protected $fillable = [
        'image_url',
        'type_id',
        'location_id',
        'name',
        'opening_hours',
        'phone',
        'rating',
    ];

    // Relationship: Store has many items
    public function items()
    {
        return $this->hasMany(Item::class);
    }

    // Relationship: Store has many orders
    public function orders()
    {
        return $this->hasMany(Order::class);
    }

    public function location(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'location_id', 'id');
    }

    public function type(): BelongsTo
    {
        return $this->belongsTo(Type::class);
    }

    public function favorites()
    {
        return $this->morphMany(Favorite::class, 'favoritable');
    }
}
