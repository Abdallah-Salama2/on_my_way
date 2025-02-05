<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;

class DeliveryPersonnel extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'location_id',
        'vehicle_id',
        'name',
        'email',
        'phone',
        'license_number',
        'password',
        'is_available',
    ];

    // Delivery personnel has one vehicle
    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class);
    }

    // Delivery personnel has many deliveries
    public function deliveries()
    {
        return $this->hasMany(Delivery::class);
    }

    public function location(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'location_id', 'id');
    }
}
