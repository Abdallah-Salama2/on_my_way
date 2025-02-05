<?php

namespace App\Services;

use App\Repositories\FavoriteRepository;
use App\Repositories\StoreRepository;
use App\Repositories\ItemRepository;

class FavoriteService
{
    protected $favoriteRepository;
    protected $storeRepository;
    protected $itemRepository;

    public function __construct(FavoriteRepository $favoriteRepository, StoreRepository $storeRepository, ItemRepository $itemRepository)
    {
        $this->favoriteRepository = $favoriteRepository;
        $this->storeRepository = $storeRepository;
        $this->itemRepository = $itemRepository;
    }

    public function getUserFavorites($userId, $filters)
    {
        return $this->favoriteRepository->getFavoritesByTypeAndMainType($userId, $filters);
    }

    public function toggleFavorite($userId, $type, $favoritableId)
    {
        $model = $type === 'store' ? $this->storeRepository : $this->itemRepository;

        if (!$model->exists($favoritableId)) {
            return ['message' => 'The selected entity does not exist.'];
        }

        $favorite = $this->favoriteRepository->findByUserAndType($userId, $type, $favoritableId);

        if ($favorite) {
            $favorite->delete();
            return ['message' => 'Removed from favorites.'];
        }

        $this->favoriteRepository->create($userId, $type, $favoritableId);
        return ['message' => 'Added to favorites.'];
    }
}
