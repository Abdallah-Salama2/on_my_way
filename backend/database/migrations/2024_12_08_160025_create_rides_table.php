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
        Schema::create('rides', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->foreignId('pickup_location_id')->nullable()->constrained('locations')->onDelete('cascade');
            $table->foreignId('drop_off_location_id')->nullable()->constrained('locations')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('driver_id')->nullable()->constrained('drivers')->onDelete('cascade');
            $table->decimal('fare', 8, 2);
            $table->string('status')->default('pending');
            $table->timestamp('start_time')->nullable();
            $table->timestamp('end_time')->nullable();
            $table->timestamps();

            // Additional indexes
            $table->index(['pickup_location_id', 'drop_off_location_id']); // For location-based searches
            $table->index('driver_id'); // For finding rides by driver
            $table->index('status'); // For filtering by ride status
            $table->index('fare'); // If sorting or filtering by fare
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rides');
    }
};
