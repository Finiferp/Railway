<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class stationController extends Controller
{
    public function getStationById(Request $request)
    {
        $stationId = $request->route('id');

        $inputData = ['id' => $stationId];

        try {
            $dbOutput = DB::select('CALL sp_getStation(?)', [json_encode($inputData)]);
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

    public function getAllStations(Request $request)
    {
        try {
            $dbOutput = DB::select('CALL sp_getStations()');
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

    public function createStation(Request $request)
    {
        try {
            $name = $request->input('name');
            $assetId = $request->input('assetId');
            $inputData = ['name' => $name, 'assetId' => $assetId];
            $dbOutput = DB::select('CALL sp_createStation(?)', [json_encode($inputData)]);

            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['station'])) {
                $station = $result['station'];
                return response()->json([
                    'message' => $message,
                    'station' => $station,
                ], $statusCode);
            } else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }
        } catch (\Exception $error) {
            \Log::error($error);
        }
    }

    public function getStationByName(Request $request)
    {
        try {
            $station_name = $request->input('station_name');
            $inputData = ['station_name' => $station_name];
            $dbOutput = DB::select('CALL sp_getStationByName(?)', [json_encode($inputData)]);

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
        }
    }
}
