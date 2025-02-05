<?php

namespace App\Repositories;

use App\Models\Favorite;

class FavoriteRepository
{
    public function getFavoritesByTypeAndMainType($userId, $filters)
    {
        return Favorite::where('user_id', $userId)
            ->where('favoritable_type', $filters['type'])
            ->with(['favoritable' => function ($query) use ($filters) {
                if ($filters['main_type']) {
                    $query->filterByMainType($filters['main_type']);
                }
            }])
            ->paginate(8);
    }

    public function findByUserAndType($userId, $type, $favoritableId)
    {
        return Favorite::where('user_id', $userId)
            ->where('favoritable_type', $type)
            ->where('favoritable_id', $favoritableId)
            ->first();
    }

    public function create($userId, $type, $favoritableId)
    {
        return Favorite::create([
            'user_id' => $userId,
            'favoritable_type' => $type,
            'favoritable_id' => $favoritableId,
        ]);
    }
}
