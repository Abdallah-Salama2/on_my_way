<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FavoriteResource extends JsonResource
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
            'favoritable' => $this->whenLoaded('favoritable', function () {
                // Dynamically resolve the favoritable resource
                if ($this->favoritable) {
                    if ($this->favoritable_type === 'App\Models\Item') {
                        return new ItemResource($this->favoritable);
                    } elseif ($this->favoritable_type === 'App\Models\Store') {
                        return new StoreResource($this->favoritable);
                    }
                }
                return null;
            }),
        ];
    }
}
