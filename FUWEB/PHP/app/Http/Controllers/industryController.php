<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class industryController extends Controller
{
    public function getIndustryById(Request $request)
    {
        $industryId = $request->route('id');

        $inputData = ['id' => $industryId];

        try {
            $dbOutput = DB::select('CALL sp_getIndustry(?)', [json_encode($inputData)]);
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

    public function getAllIndustries(Request $request)
    {
        try {
            $dbOutput = DB::select('CALL sp_getIndustries()');
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

    public function createIndustry(Request $request){
        try{
            $name = $request->input('name');
            $idAsset = $request->input('idAsset');
            $type = $request->input('type');
            $inputData = ['name'=>$name,'idAsset'=>$idAsset, 'type'=>$type];
            $dbOutput = DB::select('CALL sp_createIndustry(?)', [json_encode($inputData)]);
           
            $result = json_decode($dbOutput[0]->result, true);
            $statusCode = $result['status_code'];
            $message = $result['message'];
            if (isset($result['industry'])) {
                $industry = $result['industry'];
                return response()->json([
                    'message' => $message,
                    'industry' => $industry,
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
