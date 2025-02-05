<?php

namespace App\Services;

use App\Repositories\ItemRepository;

class ItemService
{
    protected $itemRepository;

    public function __construct(ItemRepository $itemRepository)
    {
        $this->itemRepository = $itemRepository;
    }

    public function getItemsByType($type)
    {
        return $this->itemRepository->getByTypeWithPagination($type);
    }

    public function getItemById($id)
    {
        return $this->itemRepository->findById($id);
    }
}
