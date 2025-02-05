<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class DriverRegisterRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'vehicle_id' => 'required|exists:vehicles,id',
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:drivers,email',
            'phone' => 'required|string|max:15',
            'license_number' => 'required|string|max:20|unique:drivers,license_number',
            'password' => 'required|min:8|confirmed',
            'is_available' => 'required|boolean',
        ];
    }
}
