<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class MobilController extends Controller
{
    public function index()
    {
        $query = DB::connection('mysql')->table('mobils')->get();
    
        $data = $query->map(function ($item) {
            if ($item->image) {
                $item->image_url = asset('storage/' . $item->image);
            } else {
                $item->image_url = null;
            }
            return $item;
        });
    
        return response()->json($data, 200);
    }

    public function create(Request $request)
    {
        // Validasi input dari request
        $request->validate([
            'nama' => 'nullable|string|max:255',
            'merk' => 'nullable|string|max:255',
            'model' => 'nullable|string|max:255',  // Menambahkan validasi untuk model
            'transmisi' => 'nullable|string|max:255',  // Menambahkan validasi untuk transmisi
            'bahan_bakar' => 'nullable|string|max:255', // Menambahkan validasi untuk bahan_bakar
            'cc' => 'nullable|string|max:255',
            'warna' => 'nullable|string|max:255',
            'tahun' => 'nullable|string|max:4',
            'harga' => 'nullable|string|max:255',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:10240' // Validasi untuk gambar
        ]);
    
        // Menangani upload gambar jika ada
        $imagePath = null; // Inisialisasi jika tidak ada gambar
        if ($request->hasFile('image')) {
            // Periksa apakah direktori untuk menyimpan gambar ada, jika tidak maka buat
            if (!Storage::exists('public/images/mobils')) {
                Storage::makeDirectory('public/images/mobils');
            }
    
            // Simpan gambar dan ambil path-nya
            $imagePath = $request->file('image')->store('images/mobils', 'public');
        }
    
        // Menyimpan data mobil ke database
        try {
            $dataMobil = DB::connection('mysql')->table('mobils')->insert([
                'nama' => $request->input('nama'),
                'merk' => $request->input('merk'),
                'model' => $request->input('model'),  // Menyimpan model
                'transmisi' => $request->input('transmisi'),  // Menyimpan transmisi
                'bahan_bakar' => $request->input('bahan_bakar'), // Menyimpan bahan bakar
                'cc' => $request->input('cc'),
                'warna' => $request->input('warna'),
                'tahun' => $request->input('tahun'),
                'harga' => $request->input('harga'), // Menyimpan harga jika diperlukan
                'image' => $imagePath,  // Menyimpan path gambar jika ada
                'created_at' => now(),
                'updated_at' => now(),
            ]);
    
            // Jika berhasil menambah data mobil
            if ($dataMobil) {
                return response()->json([
                    'message' => 'Mobil berhasil ditambahkan!',
                    'image_path' => $imagePath, // Path gambar yang disimpan
                ], 201);
            } else {
                // Jika data gagal disimpan
                return response()->json([
                    'message' => 'Gagal menambahkan data mobil',
                ], 500);
            }
        } catch (\Exception $e) {
            // Menangani error jika terjadi exception saat proses insert
            return response()->json([
                'message' => 'Terjadi kesalahan: ' . $e->getMessage(),
            ], 500);
        }
    }
    
    
    public function update(Request $request, $id)
{
    // Validasi input dari request
    $data = $request->validate([
        'nama' => 'sometimes|required|string|max:255',
        'merk' => 'sometimes|required|string|max:255',
        'model' => 'sometimes|required|string|max:255',
        'transmisi' => 'sometimes|required|string|max:255',
        'bahan_bakar' => 'sometimes|required|string|max:255',
        'cc' => 'nullable|string|max:255',
        'warna' => 'nullable|string|max:255',
        'tahun' => 'nullable|string|max:4',
        'harga' => 'nullable|string|max:255',
        'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:10240'  // Validasi untuk gambar
    ]);

    // Menangani upload gambar jika ada
    if ($request->hasFile('image')) {
        // Ambil data mobil yang ada untuk diupdate
        $mobil = DB::connection('mysql')->table('mobils')->where('id', $id)->first();

        // Hapus gambar lama jika ada
        if ($mobil && $mobil->image) {
            Storage::disk('public')->delete($mobil->image); 
        }

        // Simpan gambar baru dan ambil path-nya
        $imagePath = $request->file('image')->store('images/mobils', 'public');
        $data['image'] = $imagePath; 
    }

    // Tambahkan waktu update
    $data['updated_at'] = now();

    // Menyimpan data mobil yang sudah diupdate
    try {
        $dataMobil = DB::connection('mysql')->table('mobils')->where('id', $id)->update($data);

        // Cek jika update berhasil
        if ($dataMobil) {
            return response()->json([
                'message' => 'Data mobil berhasil diupdate',
            ], 200);
        } else {
            return response()->json([
                'message' => 'Gagal mengupdate data mobil atau tidak ada perubahan',
            ], 500);
        }
    } catch (\Exception $e) {
        // Menangani error jika terjadi exception saat proses update
        return response()->json([
            'message' => 'Terjadi kesalahan: ' . $e->getMessage(),
        ], 500);
    }
}

    

    public function get_mobil($id)
    {
        $query = DB::connection('mysql')->table('mobils')->where('id', $id)->first();
        if ($query) {
            return response()->json($query, 200);
        } else {
            return response()->json(['message' => 'Data mobil tidak ditemukan'], 404);
        }
    }

    public function delete($id)
    {
        $dataMobil = DB::connection('mysql')->table('mobils')->where('id', $id)->delete();

        if ($dataMobil) {
            return response()->json(['message' => 'Data mobil berhasil dihapus'], 200);
        } else {
            return response()->json(['message' => 'Gagal menghapus data mobil'], 500);
        }
    }

}
