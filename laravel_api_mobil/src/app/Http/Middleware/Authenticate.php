<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Contracts\Auth\Factory as Auth;
use Illuminate\Auth\Middleware\Authenticate as Middleware;

class Authenticate extends Middleware
{
    protected $auth;

    public function __construct(Auth $auth)
    {
        $this->auth = $auth;
    }

    public function handle($request, Closure $next, ...$guards)
    {
        if ($this->auth->guard()->guest()) {
            $token = $request->header('password'); 

            if ($token) {
                $check_token = DB::connection('mysql')
                    ->table('users')
                    ->where('password', $token)
                    ->first();

                if ($check_token === null) {
                    $res['success'] = false;
                    $res['message'] = 'Permission Not Allowed';
                    return response()->json($res, 403);
                }
            } else {
                $res['success'] = false;
                $res['message'] = 'Not Authorized';
                return response()->json($res, 401);
            }
        }

        return $next($request);
    }
}
