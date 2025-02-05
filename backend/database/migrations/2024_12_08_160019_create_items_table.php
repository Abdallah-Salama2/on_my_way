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
        Schema::create('items', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->foreignId('store_id')->constrained('stores')->onDelete('cascade');
            $table->foreignId('category_id')->nullable()->constrained('categories')->onDelete('cascade');
            $table->string('name');
            $table->text('description')->nullable();
            $table->decimal('price', 10, 2);
            $table->integer('rating')->default(0);
            $table->timestamps();

            // Index frequently queried fields
            $table->index('store_id'); // Optimizes joins with the stores table
            $table->index('category_id'); // Optimizes joins with the categories table
            $table->index('name'); // For item name searches
            $table->index('rating'); // For filtering/sorting by rating
            $table->index('price'); // For filtering/sorting by price
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('items');
    }
};
