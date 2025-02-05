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
        Schema::create('deliveries', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->foreignId('delivery_personnel_id')->constrained('delivery_personnels')->onDelete('cascade');
            $table->foreignId('pickup_location_id')->nullable()->constrained('locations')->onDelete('cascade');
            $table->foreignId('drop_off_location_id')->nullable()->constrained('locations')->onDelete('cascade');
            $table->decimal('fare', 8, 2);
            $table->timestamp('delivery_time')->nullable();
            $table->string('status')->default('pending');
            $table->timestamps();

            // Additional indexes
            $table->index('delivery_personnel_id'); // For filtering deliveries by personnel
            $table->index(['pickup_location_id', 'drop_off_location_id']); // Location-based queries
            $table->index('status'); // For filtering by delivery status
            $table->index('fare'); // For sorting or filtering by fare
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('deliveries');
    }
};
