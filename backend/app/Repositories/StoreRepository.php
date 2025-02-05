<?php

namespace App\Repositories;

use App\Models\Store;

class StoreRepository
{
    public function findByType($type)
    {
        return Store::with('favorites')->where('type_id', $type)->get();
    }

    public function findById($id)
    {
        return Store::find($id);
    }
}
