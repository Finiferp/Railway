<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Illuminate\Support\Str;
use Firebase\JWT\JWT;

class playerController extends Controller
{
    public function getPlayerById(Request $request, $id){
        $userId = (int) $id;
        $inputData = ['userId' => $userId];

        try {
            $dbOutput = DB::select('CALL spGetPlayer(?)', [json_encode($inputData)]);
            $result = $dbOutput[0][0]->result;
            $statusCode = $result->status_code;
            $message = $result->message;
            $data = $result->data;

            return response()->json([
                'message' => $message,
                'data' => $data,
            ], $statusCode);
        } catch (\Exception $error) {
           // \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    public function getAllPlayers(Request $request){
        try {
            $dbOutput = DB::select('CALL sp_getPlayers()');
            $result = json_decode($dbOutput[0]->result,true);
            $statusCode = json_decode($result->status_code,true);
            Log::info($statusCode);
            $message = json_decode($result->message,true);
            $data =json_decode( $result->data,true);

            return response()->json([
                'message' => $message,
                'data' => $data,
            ], $statusCode);
        } catch (\Exception $error) {
           // \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    public function register(Request $request)
    {
        try {
            $username = $request->input('username');
            $inputPassword = $request->input('input_password');

            if (empty($username) || empty($inputPassword)) {
                return response()->json(['error' => 'Invalid input, object invalid'], 400);
            }

            $salt = bin2hex(random_bytes(32));
            $password = hash_pbkdf2("sha512", $inputPassword, $salt, 10000, 512);
            $inputData = ['username' => $username, 'password' => $password, 'salt' => $salt];

            $dbOutput = DB::select('CALL spRegister(?)', [json_encode($inputData)]);
            $result = $dbOutput[0][0]->result;
            $statusCode = $result->status_code;
            $message = $result->message;
            $user = $result->user;
            $newWorldCreated = $result->new_world_created;
            $newWorldId = $result->new_world_id;

            if ($newWorldCreated === 1) {
                $this->generateWorld($newWorldId);
            }

            return response()->json([
                'message' => $message,
                'user' => $user,
            ], $statusCode);
        } catch (\Exception $error) {
        //    \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    public function login(Request $request)
    {
        try {
            $username = $request->input('username');
            $inputPassword = $request->input('input_password');

            $saltOutput = DB::select('CALL spGetSalt(?)', [$username]);
            $salt = $saltOutput[0][0]->salt;

            if (empty($username) || empty($inputPassword) || $salt === null) {
                return response()->json(['error' => 'Invalid input, object invalid'], 400);
            }

            $password = $this->validatePassword($inputPassword, $salt);
            $token = $this->generateAuthToken($username);
            $inputData = ['username' => $username, 'password' => $password, 'token' => $token];

            $dbOutput = DB::select('CALL spLogin(?)', [json_encode($inputData)]);
            $result = $dbOutput[0][0]->result;
            $statusCode = $result->status_code;
            $message = $result->message;
            $user = $result->user;

            return response()->json([
                'message' => $message,
                'user' => $user,
                'token' => $token,
            ], $statusCode);
        } catch (\Exception $error) {
        //    \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    private function validatePassword($password, $salt)
    {
        return hash_pbkdf2("sha512", $password, $salt, 10000, 512);
    }

    private function generateAuthToken($username)
    {
        $payload = [
            'username' => $username,
            'exp' => time() + 12 * 3600,
        ];
        $jwtKey = config('app.jwt_key') ?? 'RailwayImperiumSecret';
        //$token = JWT::encode($payload, $jwtKey);
       // \Log::info(JWT::decode($token, $jwtKey, ['HS256']));
       // return $token;
    }

    private function generateWorld($worldId)
    {
        $gridSize = 1000;
        $minDistance = 50;
        $numTowns = 15;
        $numRuralBusinesses = 30;

        $towns = [];
        $ruralBusinesses = [];

        // Generate towns
        for ($i = 0; $i < $numTowns; $i++) {
            $position = $this->generateRandomPosition(array_merge($towns, $ruralBusinesses), $gridSize, $minDistance);
            $towns[] = $position;
        }

        // Generate rural businesses
        for ($i = 0; $i < $numRuralBusinesses; $i++) {
            $position = $this->generateRandomPosition(array_merge($towns, $ruralBusinesses), $gridSize, $minDistance);
            $ruralBusinesses[] = $position;
        }

        try {
            foreach ($towns as $i => $town) {
                $jsonData = json_encode([
                    'type' => 'TOWN',
                    'name' => 'Town ' . $i,
                    'position' => $town,
                    'worldId' => $worldId,
                ]);
                $res = DB::select('CALL spCreateAsset(?)', [$jsonData]);
            }

            foreach ($ruralBusinesses as $i => $ruralBusiness) {
                $jsonData = json_encode([
                    'type' => 'RURALBUSINESS',
                    'name' => 'Rural Business' . $i,
                    'position' => $ruralBusiness,
                    'worldId' => $worldId,
                ]);
                $res = DB::select('CALL spCreateAsset(?)', [$jsonData]);
            }
        } catch (\Exception $error) {
        //    \Log::error($error);
        }
    }

    private function generateRandomPosition($existingPositions, $gridSize, $minDistance)
    {
        do {
            $x = rand(0, $gridSize - 1);
            $y = rand(0, $gridSize - 1);
        } while ($this->hasMinDistance($existingPositions, $x, $y, $minDistance));

        return compact('x', 'y');
    }

    private function hasMinDistance($existingPositions, $newX, $newY, $minDistance)
    {
        foreach ($existingPositions as $position) {
            $distance = hypot($newX - $position['x'], $newY - $position['y']);
            if ($distance < $minDistance) {
                return true;
            }
        }
        return false;
    }
}
