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
        Schema::create('data_dosens', function (Blueprint $table) {
            $table->id();
            $table->string('nama_dosen');
            $table->string('lulusan');
            $table->string('email');
            $table->dateTime('ttl');
            $table->string('kode_dosen');
            $table->string('alamat');
            $table->string('jabatan_fungsional');
            $table->enum('agama', ['islam', 'kristen', 'katolik', 'hindu', 'budha', 'konghucu']);
            $table->enum('jenis_kelamin', ['laki-laki', 'perempuan']);
            $table->enum('status', ['aktif', 'nonaktif']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_dosens');
    }
};
