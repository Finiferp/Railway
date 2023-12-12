<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\DB;
use Firebase\JWT\JWT;   
use Firebase\JWT\Key;


class AuthenticateTokenMiddleware
{
    public function handle($request, Closure $next)
    {
        $token = $request->header('Authorization');

        if (!$token) {
            return response()->json(['error' => 'No authorization provided. Expecting token!'], 401);
        }

        try {
            $tokenExistsResult = DB::select("CALL sp_checkTokenExists(?)", [$token]);
            $tokenExists = $tokenExistsResult[0]->result;
            
            if (!$tokenExists) {
                return response()->json(['error' => 'Unauthorized: Invalid token'], 401);
            }
            $decoded = JWT::decode($token, new Key('RailwayImperiumSecret', 'HS256'));

            $request->attributes->add(['decoded' => $decoded]);
            return $next($request);
        } catch (\Exception $e) {
            report($e);

            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }
}
