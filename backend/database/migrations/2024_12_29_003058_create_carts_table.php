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
        Schema::create('carts', function (Blueprint $table) {
            $table->id(); // Primary Key
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Links cart to a user
            $table->foreignId('item_id')->constrained()->onDelete('cascade'); // Links cart to an item
            $table->integer('quantity')->unsigned()->default(1); // Quantity of the item
            $table->decimal('total_price', 8, 2)->default(0.00);

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('carts');
    }
};
