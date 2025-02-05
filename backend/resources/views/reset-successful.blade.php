<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset Successful</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">

    <div class="w-full max-w-md bg-white rounded-lg shadow-lg p-8 text-center">
        <!-- Success Icon -->
        <div class="flex justify-center items-center mb-6">
            <div class="bg-green-100 text-green-500 w-16 h-16 flex items-center justify-center rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m0 6v2a2 2 0 01-2 2H7a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v2" />
                </svg>
            </div>
        </div>

        <!-- Success Message -->
        <h2 class="text-2xl font-bold text-gray-800 mb-4">Password Reset Successful!</h2>
        <p class="text-gray-600 mb-6">
            {{ $status }}
        </p>


    </div>

</body>
</html>
