<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('payments', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('delivery_id')->nullable()->constrained('deliveries')->onDelete('cascade');
            $table->foreignId('ride_id')->nullable()->constrained('rides')->onDelete('cascade');
            $table->decimal('amount', 8, 2);
            $table->string('payment_method');
            $table->string('status')->default('pending');
            $table->timestamps();

            // Additional indexes
            $table->index('user_id'); // For filtering payments by user
            $table->index('delivery_id'); // For filtering payments related to deliveries
            $table->index('ride_id'); // For filtering payments related to rides
            $table->index('status'); // For filtering by payment status
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
