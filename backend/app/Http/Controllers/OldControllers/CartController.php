<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\Item;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class CartController extends Controller
{
    use HttpResponses; // Include HttpResponses trait for reusable response methods

    protected $userId;

    public function __construct()
    {
        $this->middleware(function ($request, $next) {
            $this->userId = auth()->user()->id;
            return $next($request);
        });
    }

    public function index()
    {
        $cart = Cart::where('user_id', $this->userId)->get();
        return $this->success('Cart retrieved successfully', $cart);
    }

    /**
     * Update the quantity of a product in the cart.
     */
    public function update(Request $request)
    {
        $itemId = $request->query('itemId');
        $quantity = $request->query('quantity');
        $operator = $request->query('operator');

        // Validate required parameters
        if (!$itemId) {
            return $this->failure('itemId parameter is required');
        }

        if (!$quantity) {
            return $this->failure('quantity parameter is required');
        }

        if (!$operator) {
            return $this->failure('operator parameter is required');
        }

        // Validate input
        $request->validate([
            'quantity' => 'integer|min:1', // Ensure quantity is a positive integer
        ]);

        // Find the cart item for the authenticated user
        $cart = Cart::where('user_id', $this->userId)
            ->where('item_id', $itemId)
            ->first();

        // If cart item exists, update it
        if ($cart) {
            if ($operator === "add") {
                $cart->quantity += (int)$quantity; // Increment quantity
            } elseif ($operator === "subtract") {
                $cart->quantity -= (int)$quantity; // Decrement quantity
                if ($cart->quantity < 1) {
                    $cart->delete(); // Remove item if quantity < 1
                    return $this->success('Cart item removed successfully');
                }
            }

            // Recalculate total price
            $item = $cart->item; // Eager-loaded relationship
            $cart->total_price = ($item->price ?? 0) * $cart->quantity;
            $cart->save();

            return $this->success('Cart updated successfully', $cart);
        }

        // If cart item doesn't exist, create a new cart entry
        $item = Item::find($itemId);

        if (!$item) {
            return $this->failure('Item not found', null, 404);
        }

        $itemPrice = (float)$item->price;

        $newCart = Cart::create([
            'user_id' => $this->userId,
            'item_id' => (int)$itemId,
            'quantity' => (int)$quantity,
            'total_price' => $itemPrice * $quantity, // Calculate total price
        ]);

        return $this->success('Cart item created successfully', $newCart);
    }

    public function delete($itemId)
    {
        $cart = Cart::where("user_id", $this->userId)
            ->where('item_id', $itemId)
            ->first();

        if ($cart) {
            $cart->delete();
            return  $this->success('Cart item removed successfully',);
        }

        return $this->failure('Cart Item not found', null, 404);
    }
}
