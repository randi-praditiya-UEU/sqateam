<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DataDosenController extends Controller
{
    public function index()
    {
        $query = DB::connection('mysql')->table('data_dosens')->get();
        return response()->json($query, 200);
    }

    public function get_dosen($id)
    {
        $query = DB::connection('mysql')->table('data_dosens')->where('id', $id)->first();
        if ($query) {
            return response()->json($query, 200);
        } else {
            return response()->json(['message' => 'Data dosen tidak ditemukan'], 404);
        }
    }
    
    public function create(Request $request)
    {
        $request->validate([
            'nama_dosen' => 'nullable|string|max:255',
            'lulusan' => 'nullable|string|max:255',
            'email' => 'nullable|string|email|max:255|unique:data_dosens,email',
            'ttl' => 'nullable|date_format:Y-m-d H:i:s',
            'kode_dosen' => 'nullable|string|max:100|unique:data_dosens,kode_dosen',
            'alamat' => 'nullable|string|max:255',
            'agama' => 'nullable|in:islam,kristen,katolik,hindu,budha,konghucu',
            'jenis_kelamin' => 'nullable|in:laki-laki,perempuan',
            'jabatan_fungsional' => 'nullable|string|max:255',
            'status' => 'nullable|in:aktif,nonaktif',
        ]);

        $dataDosen = DB::connection('mysql')->table('data_dosens')->insert([
            'nama_dosen' => $request->input('nama_dosen'),
            'lulusan' => $request->input('lulusan'),
            'email' => $request->input('email'),
            'ttl' => $request->input('ttl'),
            'kode_dosen' => $request->input('kode_dosen'),
            'alamat' => $request->input('alamat'),
            'agama' => $request->input('agama'),
            'jenis_kelamin' => $request->input('jenis_kelamin'),
            'jabatan_fungsional' => $request->input('jabatan_fungsional'),
            'status' => $request->input('status'),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        if ($dataDosen) {
            return response()->json(['message' => 'Dosen berhasil di tambahkan !!'], 201);
        } else {
            return response()->json(['message' => 'Gagal menambahkan data dosen'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $data = $request->validate([
            'nama_dosen' => 'sometimes|required|string|max:255',
            'lulusan' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|string|email|max:255|unique:data_dosens,email,' . $id,
            'ttl' => 'sometimes|required|date_format:Y-m-d H:i:s',
            'kode_dosen' => 'sometimes|required|string|max:100|unique:data_dosens,kode_dosen,' . $id,
            'alamat' => 'sometimes|required|string|max:255',
            'agama' => 'sometimes|required|in:islam,kristen,katolik,hindu,budha,konghucu',
            'jenis_kelamin' => 'sometimes|required|in:laki-laki,perempuan',
            'jabatan_fungsional' => 'sometimes|required|string|max:255',
            'status' => 'sometimes|required|in:aktif,nonaktif',
        ]);

        $data['updated_at'] = now();

        $dataDosen = DB::connection('mysql')->table('data_dosens')->where('id', $id)->update($data);

        if ($dataDosen) {
            return response()->json(['message' => 'Data dosen berhasil diupdate'], 200);
        } else {
            return response()->json(['message' => 'Gagal mengupdate data dosen'], 500);
        }
    }

    public function delete($id)
    {
        $dataDosen = DB::connection('mysql')->table('data_dosens')->where('id', $id)->delete();

        if ($dataDosen) {
            return response()->json(['message' => 'Data dosen berhasil dihapus'], 200);
        } else {
            return response()->json(['message' => 'Gagal menghapus data dosen'], 500);
        }
    }
}
