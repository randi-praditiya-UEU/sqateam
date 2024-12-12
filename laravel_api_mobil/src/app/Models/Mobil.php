<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Mobil extends Model
{
    use HasFactory;
    protected $connection = 'mysql';
    protected $table = 'mobils';
    protected $fillable = [ 'nama', 'merk', 'model', 'transmisi', 'bahan_bakar', 'cc', 'warna', 'tahun', 'harga', 'image' ];
}
