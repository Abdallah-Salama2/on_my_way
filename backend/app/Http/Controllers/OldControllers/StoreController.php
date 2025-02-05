<?php

namespace App\Http\Controllers;

use App\Http\Resources\StoreResource;
use App\Models\Store;
use App\Traits\HttpResponses;
use Exception;
use Illuminate\Http\Request;

class StoreController extends Controller
{
    use HttpResponses;

    public function index2(Request $request)
    {
        $type = $request->query('type');

        if (!$type) {
            return $this->failure('Type parameter is required');
        }

        $stores = Store::with('favorites')->where('type_id', $type)->get();

        return $this->success(
            'Stores retrieved successfully',
            StoreResource::collection($stores)
        );
    }

    public function show(string $id)
    {
        $store = Store::find($id);

        if (!$store) {
            return $this->failure('Store not found');
        }

        $store->load('items');

        return $this->success('Store retrieved successfully', $store);
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
