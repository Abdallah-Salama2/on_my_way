<?php

namespace App\Http\Controllers;

use App\Models\Ride;
use App\Services\OrderService;
use App\Services\RideService;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    use HttpResponses;

    protected $orderService;
    protected $rideService;

    public function __construct(OrderService $orderService, RideService $rideService)
    {
        $this->orderService = $orderService;
        $this->rideService = $rideService;
    }

    /**
     * Display a listing of the user's orders.
     */
    public function index(Request $request)
    {
        $type = $request->query('type');

        if (!$type) {
            return $this->failure('Type parameter is required');
        }

        $userId = auth()->user()->id;

        if ($type == "food") {
            $orders = $this->orderService->getUserOrders($userId);
            return $this->success('My Orders fetched successfully.', $orders);
        } elseif ($type == "rides") {
            $rides = $this->rideService->getUserRides($userId);
            return $this->success('My Rides fetched successfully.', $rides);
        }

        // Optional: Handle invalid `type` values
        return $this->failure('Invalid type parameter.');
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

    public function cancelOrder($orderId)
    {
        try {
            $this->orderService->cancelOrder($orderId);

            return $this->success('order canceled successfully.');
        } catch (\Exception $e) {
            return $this->failure('An error occurred while canceling the order.', [
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function reorder($orderId)
    {
        try {
            $newOrder = $this->orderService->reorder($orderId);

            return $this->success('Order reordered successfully.', $newOrder);
        } catch (\Exception $e) {
            return $this->failure('An error occurred while reordering.', [
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}
