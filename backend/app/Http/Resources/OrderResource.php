<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
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
            'order_amount' => $this->order_amount,
            'order_time' => $this->order_time,
            'status' => $this->status,
            'order_items' => OrderItemResource::collection($this->whenLoaded('orderItems')),

        ];
    }
}
