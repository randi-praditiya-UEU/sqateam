<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('mobils', function (Blueprint $table) {
            $table->id();
            $table->string('nama')->nullable();
            $table->string('merk')->nullable();
            $table->string('model')->nullable();
            $table->string('transmisi')->nullable();
            $table->string('bahan_bakar')->nullable();
            $table->string('cc')->nullable();
            $table->string('warna')->nullable();
            $table->string('tahun')->nullable();
            $table->string('harga')->nullable();
            $table->string('image')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mobils');
    }
};
