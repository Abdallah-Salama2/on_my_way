<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Traits\HttpResponses;
use App\Mail\emailMailable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;

class EmailController extends Controller
{
    use HttpResponses;

    public function send(): JsonResponse
    {
        $user = Auth::user();

        if (!$user) {
            return $this->failure('User is not authenticated.', null, 401);
        }

        try {
            Mail::to($user->email)->send(new emailMailable($user));
            return $this->success('Email sent successfully.');
        } catch (\Exception $e) {
            return $this->failure('Failed to send email.', [
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
