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
        Schema::create('vehicles', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->string('type');
            $table->string('model');
            $table->string('color');
            $table->string('registration_number')->unique(); // Already indexed
            $table->integer('capacity')->default(0);
            $table->timestamps();

            // Additional index for frequently queried fields
            $table->index('type'); // For filtering by vehicle type
            $table->index('capacity'); // For filtering vehicles by capacity
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('vehicles');
    }
};
