<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateUserProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Ensure the user is authenticated
    }

    public function rules(): array
    {
        return [
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $this->user()->id,
            'password' => 'sometimes|string|min:8|confirmed',
            'location' => 'sometimes|string|max:255',
            // Add more fields as needed
        ];
    }
}
