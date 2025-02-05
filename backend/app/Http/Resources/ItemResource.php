<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ItemResource extends JsonResource
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
            'store_id' => $this->store_id,
            'category_id' => $this->category_id,
            'name' => $this->name,
            'description' => $this->description,
            'price' => $this->price,
            'rating' => $this->rating,
            'favoriteStats' => $this->favorites()->where('user_id', auth()->id())->exists(),
            'category' => $this->whenLoaded('category'),
            'store' => new StoreResource($this->whenLoaded('store')),
            // Add favorite stats

        ];
    }
}
