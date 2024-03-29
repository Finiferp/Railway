<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Illuminate\Support\Str;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class playerController extends Controller
{
    /**
     * Get a player by their ID.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPlayerById(Request $request)
    {
        $userId = $request->route('id');

        $inputData = ['userId' => (int)$userId];

        try {
            $dbOutput = DB::select('CALL sp_getPlayer(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if(isset($result['data'])){
             $data = $result['data'];

                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    /**
     * Get all players.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getAllPlayers(Request $request)
    {
        try {
            $dbOutput = DB::select('CALL sp_getPlayers()');
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            $data = $result['data'];

            return response()->json([
                'message' => $message,
                'data' => $data,
            ], $statusCode);
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    /**
     * Register a new player.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request)
    {
        try {
            $username = $request->input('username');
            $inputPassword = $request->input('input_password');

            if (empty($username) || empty($inputPassword)) {
                return response()->json(['error' => 'Invalid input, object invalid'], 400);
            }

            $salt = bin2hex(random_bytes(32));

            $passwordBin = hash_pbkdf2("sha512", $inputPassword, $salt, 10000, 512, true);
            $password = bin2hex($passwordBin);
            $inputData = ['username' => $username, 'password' => $password, 'salt' => $salt];
            $dbOutput = DB::select('CALL sp_register(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if (isset($result['user'], $result['new_world_created'], $result['new_world_id'])) {

                $user = $result['user'];
                $newWorldCreated = $result['new_world_created'];
                $newWorldId = $result['new_world_id'];
                if ($newWorldCreated === 1) {
                    $this->generateWorld($newWorldId);
                }

                return response()->json([
                    'message' => $message,
                    'user' => $user,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }
    
    /**
     * Login a player.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        try {
            $username = $request->input('username');
            $inputPassword = $request->input('input_password');

            $saltOutput = DB::select('CALL sp_getSalt(?)', [$username]);
            $salt = $saltOutput[0]->salt;

            if (empty($username) || empty($inputPassword) || $salt === null) {
                return response()->json(['error' => 'Invalid input, object invalid'], 400);
            }

            $password = $this->validatePassword($inputPassword, $salt);
            $token = $this->generateAuthToken($username);
            $inputData = ['username' => $username, 'password' => $password, 'token' => $token];
            $dbOutput = DB::select('CALL sp_login(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if (isset($result['user']) && $result['user'] !== null) {
                $user = $result['user'];
                return response()->json([
                    'message' => $message,
                    'user' => $user,
                    'token' => $token,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }
    
    /**
     * Get a player's stockpile.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPlayerStockpile(Request $request)
    {
        try {
            $userId = $request->input('userId');

            $inputData = ['userId' => (int)$userId];
            $dbOutput = DB::select('CALL sp_getPlayerRailways(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if (isset($result['user']) && $result['user'] !== null) {
                $data = $result['data'];
                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }
    /**
     * Get a player's needs.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPlayerNeeds(Request $request)
    {
        try {
            $userId = $request->input('userId');

            $inputData = ['userId' => (int)$userId];
            $dbOutput = DB::select('CALL sp_getPlayerNeeds(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if (isset($result['user']) && $result['user'] !== null) {
                $data = $result['data'];
                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    /**
     * Get a player's railways.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPlayerRailways(Request $request)
    {
        try {
            $userId = $request->input('userId');

            $inputData = ['userId' => (int)$userId];
            $dbOutput = DB::select('CALL sp_getPlayerRailways(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if (isset($result['user']) && $result['user'] !== null) {
                $data = $result['data'];
                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    /**
     * Get a player's trains.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPlayerTrains(Request $request)
    {
        try {
            $userId = $request->input('userId');

            $inputData = ['userId' => (int)$userId];
            $dbOutput = DB::select('CALL sp_getPlayersTrains(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if (isset($result['user']) && $result['user'] !== null) {
                $data = $result['data'];
                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    /**
     * Get a player's industries.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPlayerIndustries(Request $request)
    {
        try {
            $userId = $request->input('userId');

            $inputData = ['userId' => (int)$userId];
            $dbOutput = DB::select('CALL sp_getPlayerIndustries(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];

            if (isset($result['user']) && $result['user'] !== null) {
                $data = $result['data'];
                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }
    

    /**
     * Validate a password using a salt.
     *
     * @param string $password
     * @param string $salt
     * @return string
     */
    private function validatePassword($password, $salt)
    {
        $key = hash_pbkdf2("sha512", $password, $salt, 10000, 512, true);
        return $hexString = bin2hex($key);
    }

    /**
     * Generate an authentication token.
     *
     * @param string $username
     * @return string
     */
    private function generateAuthToken($username)
    {
        $payload = [
            'username' => $username,
            'exp' => time() + 12 * 3600,
        ];
        $jwtKey = 'RailwayImperiumSecret';
        $token = JWT::encode($payload, $jwtKey, 'HS256');
        return $token;
    }

    /**
     * Generate a world with towns and rural businesses.
     *
     * @param int $worldId
     * @return void
     */
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
                    'worldId' => (int)$worldId,
                ]);
                $res = DB::select('CALL sp_createAsset(?)', [$jsonData]);
            }

            foreach ($ruralBusinesses as $i => $ruralBusiness) {
                $business = '';
        
                if ($i < 4) {
                    $business = 'RANCH';
                } elseif ($i < 9) {
                    $business = 'FIELD';
                } elseif ($i < 14) {
                    $business = 'FARM';
                } elseif ($i < 19) {
                    $business = 'LUMBERYARD';
                } elseif ($i < 24) {
                    $business = 'PLANTATION';
                } else {
                    $business = 'MINE';
                }
        
                $jsonData = json_encode([
                    'type' => 'RURALBUSINESS',
                    'name' => 'Rural Business' . $i,
                    'position' => $ruralBusiness,
                    'worldId' => (int)$worldId,
                    'business' => $business,
                ]);
                $res = DB::select('CALL sp_createAsset(?)', [$jsonData]);
            }
        } catch (\Exception $error) {
            \Log::error($error);
        }
    }

    /**
     * Generate a random position with minimum distance.
     *
     * @param array $existingPositions
     * @param int $gridSize
     * @param int $minDistance
     * @return array
     */
    private function generateRandomPosition($existingPositions, $gridSize, $minDistance)
    {
        do {
            $x = rand(0, $gridSize - 1);
            $y = rand(0, $gridSize - 1);
        } while ($this->hasMinDistance($existingPositions, $x, $y, $minDistance));

        return compact('x', 'y');
    }

    /**
     * Check if a new position has a minimum distance from existing positions.
     *
     * @param array $existingPositions
     * @param int $newX
     * @param int $newY
     * @param int $minDistance
     * @return bool
     */
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
