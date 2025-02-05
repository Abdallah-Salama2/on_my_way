<?php

namespace App\Services;

use App\Repositories\CartRepository;
use App\Repositories\ItemRepository;

class CartService
{
    protected $cartRepository;
    protected $itemRepository;

    public function __construct(CartRepository $cartRepository, ItemRepository $itemRepository)
    {
        $this->cartRepository = $cartRepository;
        $this->itemRepository = $itemRepository;
    }

    public function getUserCart($userId)
    {
        return $this->cartRepository->getByUserId($userId);
    }

    public function updateCartItem($userId, $data)
    {
        $cartItem = $this->cartRepository->findByUserAndItem($userId, $data['itemId']);

        if ($cartItem) {
            $newQuantity = $data['operator'] === 'add'
                ? $cartItem->quantity + $data['quantity']
                : $cartItem->quantity - $data['quantity'];

            if ($newQuantity < 1) {
                $this->cartRepository->delete($cartItem->id);
                return ['message' => 'Cart item removed successfully'];
            }

            $cartItem->quantity = $newQuantity;
            $cartItem->total_price = $newQuantity * $cartItem->item->price;
            $cartItem->save();

            return ['message' => 'Cart updated successfully', 'data' => $cartItem];
        }

        $item = $this->itemRepository->findById($data['itemId']);
        if (!$item) {
            return ['message' => 'Item not found', 'data' => null];
        }

        $cartItem = $this->cartRepository->create([
            'user_id' => $userId,
            'item_id' => $data['itemId'],
            'quantity' => $data['quantity'],
            'total_price' => $data['quantity'] * $item->price,
        ]);

        return ['message' => 'Cart item created successfully', 'data' => $cartItem];
    }

    public function deleteCartItem($userId, $itemId)
    {
        $cartItem = $this->cartRepository->findByUserAndItem($userId, $itemId);

        if ($cartItem) {
            $this->cartRepository->delete($cartItem->id);
            return ['message' => 'Cart item removed successfully'];
        }

        return ['message' => 'Cart item not found'];
    }
}
