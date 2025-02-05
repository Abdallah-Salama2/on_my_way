<?php

namespace App\Http\Controllers;

use App\Http\Resources\FavoriteResource;
use App\Http\Resources\ItemResource;
use App\Http\Resources\StoreResource;
use App\Models\Favorite;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class FavoriteController extends Controller
{
    use HttpResponses;

    /**
     * Display a listing of the user's favorites.
     */
    public function indx(Request $request)
    {
        $userId = auth()->id();

        // Validate the input
        $validated = $request->validate([
            'type' => ['required', 'in:store,item'], // Allow only 'store' or 'item'
            'main_type' => ['required', 'in:supermarket,restaurant'] // Optional filter for main type
        ]);

        // Map the type input to the corresponding model
        $modelMap = [
            'store' => 'App\Models\Store',
            'item' => 'App\Models\Item',
        ];
        $favoritableType = $modelMap[$validated['type']];

        // Start building the query
        $favoritesQuery = Favorite::where('user_id', $userId)
            ->with(['favoritable' => function ($query) use ($validated) {
                // Filter based on main_type if provided
                if (isset($validated['main_type'])) {
                    if ($validated['type'] === 'item') {
                        $query->whereHas('category', function ($categoryQuery) use ($validated) {
                            $categoryQuery->whereHas('type', function ($typeQuery) use ($validated) {
                                $typeQuery->where('name', $validated['main_type']);
                            });
                        });
                    } elseif ($validated['type'] === 'store') {
                        $query->whereHas('type', function ($typeQuery) use ($validated) {
                            $typeQuery->where('name', $validated['main_type']);
                        });
                    }
                }
            }])
            ->where('favoritable_type', $favoritableType);

        // Paginate the results
        $favorites = $favoritesQuery->paginate(8);

        // Use FavoriteResource to format the response
        return $this->success('Favorites retrieved successfully.', [
            'favorites' => FavoriteResource::collection($favorites),
            'pagination' => [
                'current_page' => $favorites->currentPage(),
                'last_page' => $favorites->lastPage(),
                'per_page' => $favorites->perPage(),
                'total' => $favorites->total(),
            ]
        ]);
    }

    /**
     * Add or remove a favorite.
     */
    public function toggle(Request $request, $favoritableId)
    {
        $userId = auth()->id();

        // Validate the input
        $validated = $request->validate([
            'type' => ['required', 'in:store,item'], // Allow only 'store' or 'item'
        ]);

        // Resolve the favoritable type
        $modelMap = [
            'store' => 'App\Models\Store',
            'item' => 'App\Models\Item',
        ];
        $favoritableType = $modelMap[$validated['type']];

        // Check if the favorite already exists and toggle
        $favorite = Favorite::where([
            'user_id' => $userId,
            'favoritable_id' => $favoritableId,
            'favoritable_type' => $favoritableType,
        ])->first();

        if ($favorite) {
            $favorite->delete();
            return $this->success('Removed from favorites.');
        }

        // Verify the favoritable entity exists
        if (!app($favoritableType)->where('id', $favoritableId)->exists()) {
            return $this->failure(
                'The selected entity does not exist.',
                null,
                422 // Unprocessable Entity
            );
        }

        // Add to favorites
        Favorite::create([
            'user_id' => $userId,
            'favoritable_id' => $favoritableId,
            'favoritable_type' => $favoritableType,
        ]);

        return $this->success('Added to favorites.');
    }
}
