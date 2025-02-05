<?php

namespace App\Http\Controllers;

use App\Http\Resources\StoreResource;
use App\Services\StoreService;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class StoreController extends Controller
{
    use HttpResponses;

    protected $storeService;

    public function __construct(StoreService $storeService)
    {
        $this->storeService = $storeService;
    }

    public function index2(Request $request)
    {
        $type = $request->query('type');

        if (!$type) {
            return $this->failure('Type parameter is required');
        }

        $stores = $this->storeService->getStoresByType($type);

        return $this->success(
            'Stores retrieved successfully',
            StoreResource::collection($stores)
        );
    }

    public function show(string $id)
    {
        $store = $this->storeService->getStoreById($id);

        if (!$store) {
            return $this->failure('Store not found');
        }

        return $this->success('Store retrieved successfully', new StoreResource($store));
    }
}
