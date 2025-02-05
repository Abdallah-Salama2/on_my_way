<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vehicle extends Model
{
    use HasFactory;

    protected $fillable = [
        'image_url',
        'type',
        'model',
        'color',
        'registration_number',
        'capacity',
    ];

    // Vehicle belongs to delivery personnel
    public function personnel()
    {
        return $this->hasOne(DeliveryPersonnel::class);
    }

    // Vehicle can have one driver
    public function driver()
    {
        return $this->hasOne(Driver::class);
    }
}
