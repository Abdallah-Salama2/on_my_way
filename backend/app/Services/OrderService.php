<?php

namespace App\Services;

use App\Repositories\CartRepository;
use App\Repositories\OrderRepository;
use App\Repositories\OrderItemRepository;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class OrderService
{
    protected $orderRepository;
    protected $cartRepository;
    protected $orderItemRepository;

    public function __construct(OrderRepository $orderRepository, CartRepository $cartRepository, OrderItemRepository $orderItemRepository)
    {
        $this->orderRepository = $orderRepository;
        $this->cartRepository = $cartRepository;
        $this->orderItemRepository = $orderItemRepository;
    }

    public function getUserOrders($userId)
    {
        return $this->orderRepository->getOrdersByUserId($userId);
    }

    public function createOrderFromCart($userId, $data)
    {
        $cartItems = $this->cartRepository->getByUserId($userId);

        if ($cartItems->isEmpty()) {
            return null;
        }

        $orderAmount = $cartItems->sum('total_price');

        $order = $this->orderRepository->create([
            'user_id' => $userId,
            'store_id' => $data['store_id'] ?? null,
            'delivery_id' => $data['delivery_id'] ?? null,
            'order_amount' => (string) $orderAmount,
            'order_time' => Carbon::now(),
            'status' => 'Pending',
        ]);

        foreach ($cartItems as $cartItem) {
            $this->orderItemRepository->create([
                'order_id' => $order->id,
                'item_id' => $cartItem->item_id,
                'quantity' => $cartItem->quantity,
                'price' => $cartItem->total_price,
            ]);
        }

        // Clear the user's cart
        $this->cartRepository->clearCartByUserId($userId);

        return $order;
    }

    public function markOrderAsDelivered($orderId)
    {
        $order = $this->orderRepository->findById($orderId);

        if (!$order) {
            return [
                'success' => false,
                'message' => 'Order not found.',
                'status' => 404,
            ];
        }

        if ($order->status === 'Delivered') {
            return [
                'success' => false,
                'message' => 'Order is already marked as delivered.',
                'status' => 400,
            ];
        }

        $this->orderRepository->updateStatus($orderId, 'Delivered');

        return [
            'success' => true,
            'message' => 'Order marked as delivered successfully.',
        ];
    }


    public function cancelOrder($orderId)
    {

        try {
            // Retrieve the order
            $order = $this->orderRepository->findById($orderId);

            // Check if the user is authorized to cancel the order
            if ($order->user_id !== auth()->id()) {
                throw new \Exception('Unauthorized action.', 403);
            }

            // Update the order status to 'canceled'
            $this->orderRepository->delete($order);
        } catch (\Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }


    public function reorder($orderId)
    {
        try {
            // Retrieve the original order
            $originalOrder = $this->orderRepository->findById($orderId);

            if (!$originalOrder) {
                throw new \Exception('Order not found.', 404);
            }

            // Check if the user is authorized to reorder
            if ($originalOrder->user_id !== auth()->id()) {
                throw new \Exception('Unauthorized action.', 403);
            }

            // Start a database transaction
            DB::beginTransaction();

            // Create a new order with the same details as the original order
            $newOrder = $this->orderRepository->create([
                'user_id' => $originalOrder->user_id,
                'store_id' => $originalOrder->store_id,
                'delivery_id' => $originalOrder->delivery_id,
                'order_amount' => $originalOrder->order_amount,
                'order_time' => Carbon::now(),
                'status' => 'Pending', // Reset status for the new order
            ]);

            // Duplicate the items from the original order to the new order
            foreach ($originalOrder->orderItems as $orderItem) {
                $this->orderItemRepository->create([
                    'order_id' => $newOrder->id,
                    'item_id' => $orderItem->item_id,
                    'quantity' => $orderItem->quantity,
                    'price' => $orderItem->price,
                ]);
            }

            // Commit the transaction
            DB::commit();

            return $newOrder;
        } catch (\Exception $e) {
            // Rollback the transaction in case of an error
            DB::rollBack();
            throw $e;
        }
    }
}
