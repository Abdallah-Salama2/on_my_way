<?php

namespace App\Http\Controllers;

use App\Http\Resources\CategoryResource;
use App\Services\CategoryService;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    use HttpResponses;

    protected $categoryService;

    public function __construct(CategoryService $categoryService)
    {
        $this->categoryService = $categoryService;
    }

    /**
     * Get categories filtered by type.
     */
    public function index2(Request $request)
    {
        $type = $request->query('type');

        if (!$type) {
            return $this->failure('Type parameter is required');
        }

        try {
            $categories = $this->categoryService->getCategoriesByType($type);
            return $this->success('Categories retrieved successfully', $categories);
        } catch (\Exception $e) {
            return $this->failure('An error occurred while retrieving categories.', $e->getMessage());
        }
    }

    /**
     * Show a specific category.
     */
    public function show(string $id)
    {
        try {
            $category = $this->categoryService->getCategoryById($id);
            if (!$category) {
                return $this->failure('Category not found');
            }

            return $this->success('Category retrieved successfully', new CategoryResource($category));
        } catch (\Exception $e) {
            return $this->failure('An error occurred while retrieving the category.', $e->getMessage());
        }
    }
}
