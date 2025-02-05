<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Services\PasswordResetService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ForgotPasswordController extends Controller
{
    protected $passwordResetService;

    public function __construct(PasswordResetService $passwordResetService)
    {
        $this->passwordResetService = $passwordResetService;
    }

    public function passwordResetLink(Request $request): JsonResponse
    {
        $request->validate(['email' => ['required', 'email']]);

        $status = $this->passwordResetService->sendResetLink($request->only('email'));

        if ($status != \Password::RESET_LINK_SENT) {
            return response()->json([
                'message' => 'Failed to send password reset link.',
                'status' => __($status),
            ], 400);
        }

        return response()->json([
            'message' => 'Password reset link sent successfully.',
            'status' => __($status),
        ]);
    }

    public function newPassword(Request $request)
    {
        // Validate request data
        $data = $request->validate([
            'token' => 'required|string',
            'email' => 'required|email',
            'password' => 'required|min:8|confirmed',

        ], [
            'token.required' => 'The reset token is missing or invalid.',
            'email.required' => 'Email is required.',
            'email.email' => 'Please provide a valid email address.',
            'password.required' => 'The new password is required.',
            'password.confirmed' => 'The password confirmation does not match.',
        ]);

        // Attempt to reset password
        $status = $this->passwordResetService->resetPassword($data);

        if ($status == \Password::PASSWORD_RESET) {
            return redirect()->route('password.success', ['status' => __($status)]);
        }

        // Return error response
        return response()->json([
            'message' => 'Failed to reset password. Please try again.',
            'status' => __($status),
        ], 400);
    }

    public function passwordSuccess(Request $request)
    {
        return view('reset-successful', ['status' => $request->status]);
    }
}
