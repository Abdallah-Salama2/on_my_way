<?php

namespace App\Http\traits;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Auth;

trait FavoriteScope
{
    /**
     * Local Scope to include favorite status.
     */
    public function scopeWithFavoriteStatus(Builder $query, $userId)
    {
        return $query->with(['favorites' => function ($favoriteQuery) use ($userId) {
            $favoriteQuery->where('user_id', $userId);
        }]);
    }

    /**
     * Automatically apply global scope for authenticated users.
     */
    public static function bootFavoriteScope()
    {
        static::addGlobalScope('withFavoriteStatus', function (Builder $builder) {
            if (Auth::check()) {
                $userId = Auth::id();

                $builder->with(['favorites' => function ($favoriteQuery) use ($userId) {
                    $favoriteQuery->where('user_id', $userId);
                }]);
            }
        });
    }
}
