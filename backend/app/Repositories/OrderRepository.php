<?php

namespace App\Repositories;

use App\Http\Resources\OrderResource;
use App\Models\Order;

class OrderRepository
{
    public function getOrdersByUserId($userId)
    {
        $orders = Order::where('user_id', $userId)
            ->with([
                'orderItems.item.favorites', // Load relationships
                'store',
                'delivery',
            ])
            ->get();

        return OrderResource::collection($orders);
    }

    public function findById($orderId)
    {
        return Order::find($orderId);
    }

    public function create($data)
    {
        return Order::create($data);
    }
    public function delete($order)
    {
        $order->delete();
    }

    public function updateStatus($orderId, $status)
    {
        $order = $this->findById($orderId);

        if ($order) {
            $order->status = $status;
            $order->save();
        }

        return $order;
    }
}
