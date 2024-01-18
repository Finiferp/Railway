<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class goodController extends Controller{

    /**
     * Get a good by its ID.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
      public function getGoodById(Request $request){
            $goodId = $request->route('id');

            $inputData = ['id' => $goodId];
    
            try {
                $dbOutput = DB::select('CALL sp_getGood(?)', [json_encode($inputData)]);
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
            } catch (\Exception $error) {
                \Log::error($error);
                return response()->json(['error' => 'Internal Server Error'], 500);
            }
      }

    /**
     * Get all goods.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
      public function getAllGoods(Request $request)
    {
        try {
            $dbOutput = DB::select('CALL sp_getGoods()');
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


    
}
