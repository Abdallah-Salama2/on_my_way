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
        Schema::create('orders', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('store_id')->nullable()->constrained('stores')->onDelete('cascade');
            $table->foreignId('delivery_id')->nullable()->constrained('deliveries')->onDelete('set null');
            $table->decimal('order_amount', 10, 2);
            $table->timestamp('order_time')->useCurrent();
            $table->string('status')->default('pending'); // e.g., pending, completed, canceled
            $table->timestamps();

            // Additional indexes
            $table->index('user_id'); // For filtering orders by user
            $table->index('store_id'); // For filtering orders by store
            $table->index('status'); // For filtering by order status
            $table->index('order_time'); // For filtering or sorting by order time
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
