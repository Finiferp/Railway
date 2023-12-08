<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class assetController extends Controller
{
    public function getAssetById(Request $request)
    {
        $assetId = $request->route('id');

        $inputData = ['id' => $assetId];

        try {
            $dbOutput = DB::select('CALL sp_getAsset(?)', [json_encode($inputData)]);
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

    public function getAllAssets(Request $request)
    {
        try {
            $dbOutput = DB::select('CALL sp_getAssets()');
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

 /*   public function createAsset(Request $request){
        try{
            $type = $request->input('type');
            $name = $request->input('name');
            $position = $request->input('position');
            $worldId = $request->input('worldId');
            $dbOutput = DB::select('sp_createAsset(?)');
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['asset'])) {
                $asset = $result['asset'];
                return response()->json([
                    'message' => $message,
                    'asset' => $asset,
                ], $statusCode);
            }else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }

        } catch (error) {
            console.error(error);
            res.status(500).send('Internal Server Error');
        }
    }*/
}
