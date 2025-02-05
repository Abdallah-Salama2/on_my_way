<?php

namespace App\Repositories;

use App\Models\Item;

class ItemRepository
{
    public function getByTypeWithPagination($type)
    {
        return Item::with('category', 'store')
            ->whereHas('category', function ($query) use ($type) {
                $query->where('type_id', $type);
            })
            ->paginate(10);
    }

    public function findById($id)
    {
        return Item::with('category', 'store')->find($id);
    }

    public function exists($id)
    {
        return Item::where('id', $id)->exists();
    }
}
