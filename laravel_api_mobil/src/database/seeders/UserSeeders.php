<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class UserSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $timstamp = \Carbon\Carbon::now()->toDateString();
        DB::table('users')->insert([
            'name' => 'client',
            'email' => 'admin@admin.com',
            'password' => 'password',
             // 'password' =>  hash::make('password'),
            'created_at' => $timstamp,
            'updated_at' => $timstamp,]);
    }
}
