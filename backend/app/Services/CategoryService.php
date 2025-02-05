<?php

namespace App\Services;

use App\Repositories\CategoryRepository;

class CategoryService
{
    protected $categoryRepository;

    public function __construct(CategoryRepository $categoryRepository)
    {
        $this->categoryRepository = $categoryRepository;
    }

    public function getCategoriesByType($type)
    {
        return $this->categoryRepository->getByType($type);
    }

    public function getCategoryById($id)
    {
        return $this->categoryRepository->findById($id);
    }
}
