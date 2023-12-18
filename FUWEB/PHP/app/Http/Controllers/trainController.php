<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class trainController extends Controller
{
    public function getTrainById(Request $request)
    {
        $trainId = $request->route('id');

        $inputData = ['id' => $trainId];

        try {
            $dbOutput = DB::select('CALL sp_getTrain(?)', [json_encode($inputData)]);
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

    public function getAlltrains(Request $request)
    {
        try {
            $dbOutput = DB::select('CALL sp_getTrains()');
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

    public function createtrain(Request $request)
    {
        try {
            $name = $request->input('name');
            $idRailway = $request->input('idRailway');
            $idAsset_Starts = $request->input('idAsset_Starts');
            $idAsset_Destines = $request->input('idAsset_Destines');
            $willReturnWithGoods = $request->input('willReturnWithGoods');
            $inputData = ['name' => $name, 'idRailway' => $idRailway, 'idAsset_Starts' => $idAsset_Starts, 'idAsset_Destines' => $idAsset_Destines, 'willReturnWithGoods' => $willReturnWithGoods];
            $dbOutput = DB::select('CALL sp_createTrain(?)', [json_encode($inputData)]);

            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['train'])) {
                $train = $result['train'];
                return response()->json([
                    'message' => $message,
                    'train' => $train,
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


    public function deleteTrain(Request $request)
    {
        try {
            $trainId = $request->input('trainId');
            $userId = $request->input('userId');
            $inputData = ['trainId' => $trainId, 'userId' => $userId];
            $dbOutput = DB::select('CALL sp_deleteTrain(?)', [json_encode($inputData)]);

            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            return response()->json([
                'message' => $message,
            ], $statusCode);
        } catch (\Exception $error) {
            \Log::error($error);
        }
    }

    public function demandTrain(Request $request)
    {
        try {
            $railwayId = $request->input('railwayId');
            $assetFromId = $request->input('assetFromId');
            $assetToId = $request->input('assetToId');
            $goodId = $request->input('goodId');
            $amount = $request->input('amount');
            $inputData = ['railwayId' => $railwayId, 'assetFromId' => $assetFromId, 'assetToId' => $assetToId, 'goodId' => $goodId, 'amount' => $amount];
            $dbOutput = DB::select('CALL sp_demandTrain(?)', [json_encode($inputData)]);

            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            return response()->json([
                'message' => $message,
            ], $statusCode);
        } catch (\Exception $error) {
            \Log::error($error);
        }
    }
}
