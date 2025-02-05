<?php

namespace App\Http\Controllers;

use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    use HttpResponses;

    /**
     * Display a listing of the resource.
     */
    public function index2(Request $request)
    {
        $type = $request->query('type');

        if (!$type) {
            return $this->failure('Type parameter is required');
        }

        $items = Item::with('category', 'store')
            ->whereHas('category', function ($query) use ($type) {
                $query->where('type_id', $type);
            })
            ->paginate(10);

        return $this->success('Items retrieved successfully', ItemResource::collection($items));
    }

    public function show(string $id)
    {
        $item = Item::find($id);

        if (!$item) {
            return $this->failure('Item not found');
        }

        $item->load('category', 'store');

        return $this->success('Item retrieved successfully', $item);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
