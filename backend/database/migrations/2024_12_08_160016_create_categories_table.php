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
        Schema::create('categories', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->string('name');
            $table->string('description');
            $table->unsignedBigInteger('type_id'); // Foreign key for types
            $table->foreign('type_id')->references('id')->on('types')->onDelete('cascade');
            $table->timestamps();

            // Index frequently queried fields
            $table->index('type_id'); // Optimizes joins with the types table
            $table->index('name'); // For category searches
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};
