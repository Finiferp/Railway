<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class assetController extends Controller
{
    /**
     * Get an asset by its ID.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
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
    
    /**
     * Get all assets.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
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

    /**
     * Get assets owned by a specific player.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPlayerAssets(Request $request)
    {
        $id = $request->route('id');
        $inputData = ['id' => $id];

        try {
            $dbOutput = DB::select('CALL sp_getUserAssets(?)', [json_encode($inputData)]);
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
     * Buy an asset for a specific player.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function buyAsset(Request $request){
        try{
            $userId = $request->input('userId');
            $assetId = $request->input('assetId');
            $inputData = ['userId' => $userId,'assetId',$assetId];
            $dbOutput = DB::select('sp_buyAsset(?)', [json_encode($inputData)]);
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
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }

    /**
     * Get assets at a specific station.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getAssetsStation(Request $request){
        try{
            $assetId = $request->input('assetId');
            $inputData = ['assetId' => $assetId];
            $dbOutput = DB::select('sp_getAssetsStation(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['data'])) {
                $data = $result['data'];
                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            }else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }

        } catch (error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }
    
    /**
     * Get assets in a specific world.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getWorldAssets(Request $request){
        $worldId = $request->route('id');
        $inputData = ['worldId' => $worldId];
        try{
            $dbOutput = DB::select('sp_getWorldAssets(?)', [json_encode($inputData)]);
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['data'])) {
                $data = $result['data'];
                return response()->json([
                    'message' => $message,
                    'data' => $data,
                ], $statusCode);
            }else {
                return response()->json([
                    'message' => $message,
                ], $statusCode);
            }

        } catch (error) {
            \Log::error($error);
            return response()->json(['error' => 'Internal Server Error'], 500);
        }
    }
}
