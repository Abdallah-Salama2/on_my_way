<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Category extends Model
{
    use HasFactory;

    protected $fillable = ['type_id', 'image_url', 'name', 'description'];

    public function type(): BelongsTo
    {
        return $this->belongsTo(Type::class);
    }
    public function items(): HasMany
    {
        return $this->hasMany(Item::class);
    }
}
