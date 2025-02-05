<?php

namespace App\Repositories;

use App\Models\Category;

class CategoryRepository
{
    public function getByType($type)
    {
        return Category::where('type_id', $type)->get();
    }

    public function findById($id)
    {
        return Category::with('items')->find($id);
    }
}
