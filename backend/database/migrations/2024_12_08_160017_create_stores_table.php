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
        Schema::create('stores', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->unsignedBigInteger('type_id'); // Foreign key for types
            $table->foreign('type_id')->references('id')->on('types')->onDelete('cascade');
            $table->foreignId('location_id')->nullable()->constrained('locations')->cascadeOnDelete();
            $table->string('name');
            $table->string('opening_hours');
            $table->string('phone')->nullable();
            $table->integer('rating')->default(0); // Store's overall rating
            $table->timestamps();

            // Index frequently queried columns
            $table->index('type_id'); // For filtering/joining by type
            $table->index('location_id'); // Optimizes joins with the locations table
            $table->index('name'); // For store name searches
            $table->index('rating'); // For filtering or sorting by ratings
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stores');
    }
};
