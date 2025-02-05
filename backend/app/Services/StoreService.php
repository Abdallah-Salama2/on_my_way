<?php

namespace App\Services;

use App\Repositories\StoreRepository;

class StoreService
{
    protected $storeRepository;

    public function __construct(StoreRepository $storeRepository)
    {
        $this->storeRepository = $storeRepository;
    }

    public function getStoresByType($type)
    {
        return $this->storeRepository->findByType($type);
    }

    public function getStoreById($id)
    {
        $store = $this->storeRepository->findById($id);

        if ($store) {
            $store->load('items'); // Eager-load related items if store exists
        }

        return $store;
    }
}
