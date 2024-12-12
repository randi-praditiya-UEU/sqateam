<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DataDosen extends Model
{
    use HasFactory;
    protected $connection = 'mysql';
    protected $table = 'DataDosen';
    protected $fillable = ['nama_dosen', 'lulusan', 'email', 'ttl', 'kode_dosen','alamat','agama','jenis_kelamin','jabatan_fungsional','status'];
}
