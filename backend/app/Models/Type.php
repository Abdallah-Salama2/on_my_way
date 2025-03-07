<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Type extends Model
{
    use HasFactory;

    protected $fillable = ['name'];


    public function stores(): HasMany
    {
        return $this->hasMany(Store::class);
    }
    public function categories(): HasMany
    {
        return $this->hasMany(Category::class);
    }
}
