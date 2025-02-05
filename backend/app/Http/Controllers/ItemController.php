<?php

namespace App\Http\Controllers;

use App\Http\Resources\ItemResource;
use App\Services\ItemService;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    use HttpResponses;

    protected $itemService;

    public function __construct(ItemService $itemService)
    {
        $this->itemService = $itemService;
    }

    /**
     * Get items filtered by type with pagination.
     */
    public function index2(Request $request)
    {
        $type = $request->query('type');

        if (!$type) {
            return $this->failure('Type parameter is required');
        }

        try {
            $items = $this->itemService->getItemsByType($type);
            return $this->success('Items retrieved successfully', ItemResource::collection($items));
        } catch (\Exception $e) {
            return $this->failure('An error occurred while retrieving items.', $e->getMessage());
        }
    }

    /**
     * Show a specific item.
     */
    public function show(string $id)
    {
        try {
            $item = $this->itemService->getItemById($id);
            if (!$item) {
                return $this->failure('Item not found');
            }

            return $this->success('Item retrieved successfully', $item);
        } catch (\Exception $e) {
            return $this->failure('An error occurred while retrieving the item.', $e->getMessage());
        }
    }
}
