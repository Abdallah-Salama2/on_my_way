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
        Schema::create('delivery_personnels', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->foreignId('location_id')->nullable()->constrained('locations')->cascadeOnDelete();
            $table->foreignId('vehicle_id')->unique()->constrained('vehicles')->onDelete('cascade');
            $table->string('name');
            $table->string('email')->unique(); // Already indexed
            $table->string('phone');
            $table->string('license_number')->unique(); // Already indexed
            $table->string('password');
            $table->boolean('is_available')->default(true);
            $table->timestamps();

            // Additional index for availability
            $table->index('is_available'); // For filtering by availability
            $table->index('location_id'); // For filtering delivery personnel by location
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('delivery_personnels');
    }
};
