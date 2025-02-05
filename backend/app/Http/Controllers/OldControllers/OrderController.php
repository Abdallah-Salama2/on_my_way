<?php

namespace App\Http\Controllers;

use App\Services\OrderService;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    use HttpResponses;

    protected $orderService;

    public function __construct(OrderService $orderService)
    {
        $this->orderService = $orderService;
    }

    /**
     * Display a listing of the user's orders.
     */
    public function index()
    {
        $userId = auth()->user()->id;
        $orders = $this->orderService->getUserOrders($userId);

        return $this->success('My Orders fetched successfully.', $orders);
    }

    /**
     * Create a new order from the cart.
     */
    public function create(Request $request)
    {
        $validatedData = $request->validate([
            'store_id' => 'nullable|exists:stores,id',
            'delivery_id' => 'nullable|exists:deliveries,id',
        ]);

        $userId = auth()->user()->id;
        $order = $this->orderService->createOrderFromCart($userId, $validatedData);

        if (!$order) {
            return $this->failure('Cart is empty. Order not created.', null, 400);
        }

        return $this->success('Order created successfully.', $order);
    }

    /**
     * Mark an order as delivered.
     */
    public function markAsDelivered($orderId)
    {
        $response = $this->orderService->markOrderAsDelivered($orderId);

        if (!$response['success']) {
            return $this->failure($response['message'], null, $response['status']);
        }

        return $this->success($response['message']);
    }
}
