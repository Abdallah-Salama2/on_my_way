<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class StoreResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray($request)
    {

        return [
            'id' => $this->id,
            'image_url' => $this->image_url,
            'type_id' => $this->type_id,
            'location_id' => $this->location_id,
            'name' => $this->name,
            'opening_hours' => $this->opening_hours,
            'phone' => $this->phone,
            'rating' => $this->rating,
            'items' => ItemResource::collection($this->whenLoaded('items')),
            // Add favorite stats
            'favoriteStats' => $this->favorites()->where('user_id', auth()->id())->exists(),

        ];
    }
}
