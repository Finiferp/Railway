<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class railwayController extends Controller
{
    /**
     * Get a railway by its ID.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getRailwayById(Request $request)
    {
        $railwayId = $request->route('id');

        $inputData = ['id' => (int)$railwayId];

        try {
            $dbOutput = DB::select('CALL sp_getRailway(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['data'])) {
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
     * Get all railways.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getAllRailways(Request $request)
    {
        try {
            $dbOutput = DB::select('CALL sp_getRailways()');
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
     * Create a new railway.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function createRailway(Request $request){
        try{
            $station1Id = $request->input('station1Id');
            $station2Id = $request->input('station2Id');
            $userId = $request->input('userId');
            $inputData = ['station1Id'=>(int)$station1Id,'station2Id'=>(int)$station2Id,'userId'=> (int)$userId];
            $dbOutput = DB::select('CALL sp_createRailway(?)', [json_encode($inputData)]);
           
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['railway'])) {
                $railway = $result['railway'];
                return response()->json([
                    'message' => $message,
                    'railway' => $railway,
                ], $statusCode);
            }else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }

        }catch (\Exception $error) {
           \Log::error($error);
        }
    }
}
