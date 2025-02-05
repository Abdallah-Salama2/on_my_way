<?php

namespace App\Repositories;

use App\Models\Cart;

class CartRepository
{
    public function getByUserId($userId)
    {
        return Cart::with('item')->where('user_id', $userId)->get();
    }

    public function findByUserAndItem($userId, $itemId)
    {
        return Cart::where('user_id', $userId)->where('item_id', $itemId)->first();
    }

    public function create($data)
    {
        return Cart::create($data);
    }

    public function delete($id)
    {
        return Cart::where('id', $id)->delete();
    }

    public function clearCartByUserId($userId)
    {
        return Cart::where('user_id', $userId)->delete();
    }
}
