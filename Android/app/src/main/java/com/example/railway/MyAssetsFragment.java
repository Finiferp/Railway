package com.example.railway;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.PopupWindow;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.example.railway.databinding.FragmentMyAssetsBinding;
import com.example.railway.ressources.MyAsset;
import com.example.railway.ressources.WorldsAsset;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class MyAssetsFragment extends Fragment {

    private final String[] assetsHeaders = {"Name","Type","Population","Level","Station"};
    private ArrayList<MyAsset> alMyAssets = new ArrayList<>();
    private FragmentMyAssetsBinding binding;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentMyAssetsBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        apiCall();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

    private void apiCall(){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int id = preferences.getInt("id", -1);


        String url = "http://192.168.129.37:3000/asset/player/"+id;
        //String url = "http://192.168.178.39:3000/asset/player/"+id;

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONArray data = jsonResponse.optJSONArray("data");
                            System.out.println(data);
                            for(int i = 0; i< data.length();i++){
                                JSONObject asset = (JSONObject) data.get(i);
                                String name = asset.getString("name");
                                String type = asset.getString("type");
                                String level = asset.getString("level");
                                String population = asset.getString("population");
                                int assetId = asset.getInt("assetId");
                                getStationName(assetId, new StationCallback() {
                                    @Override
                                    public void onStationReceived(String stationName) {
                                        MyAsset myAsset = new MyAsset(name, type, population, level, stationName,assetId);
                                        alMyAssets.add(myAsset);
                                        if (alMyAssets.size() == data.length()) {
                                                populate();
                                        }
                                    }
                                });

                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                if(error.networkResponse != null && error.networkResponse.data !=null) {
                    System.out.println("ERRORRR");

                }else {
                    System.out.println("Error: "+ error.toString());
                }
            }
        }) {
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                headers.put("Authorization", token);
                return headers;
            }
        };

        queue.add(stringRequest);
    }

    private interface StationCallback {
        void onStationReceived(String stationName);
    }
    private void getStationName(int id, MyAssetsFragment.StationCallback callback){

        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");

        String url = "http://192.168.129.37:3000/asset/station";
        //String url = "http://192.168.178.39:3000/asset/station";

        JSONObject jsonBody = new JSONObject();
        try {
            jsonBody.put("assetId",id);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONObject data = jsonResponse.optJSONObject("data");
                            String stationName = data.optString("name","No Station");
                            callback.onStationReceived(stationName);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                if(error.networkResponse != null && error.networkResponse.data !=null) {
                    String stationName = "No Station";
                    callback.onStationReceived(stationName);
                    System.out.println("ERRORRR");

                }else {
                    System.out.println("Error: "+ error.toString());
                }
            }
        }) {
            @Override
            public byte[] getBody() {

                return jsonBody.toString().getBytes();
            }

            @Override
            public String getBodyContentType() {
                return "application/json";
            }
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                headers.put("Authorization", token);
                return headers;
            }
        };

        queue.add(stringRequest);
    }


    private void populate() {

        TableLayout tableLayout = binding.myAssetsTableLayout;
        tableLayout.removeAllViews();
        TableRow headersRow = new TableRow(getContext());

        for (int i = 0; i < assetsHeaders.length; i++) {
            TextView temp = new TextView(getContext());
            temp.setText(assetsHeaders[i]);
            headersRow.addView(temp);
        }
        tableLayout.addView(headersRow);

        for(MyAsset asset : alMyAssets){
            TableRow row = new TableRow(getContext());

            TextView nameTextView = new TextView(getContext());
            nameTextView.setText(asset.getName());
            row.addView(nameTextView);

            TextView typeTextView = new TextView(getContext());
            typeTextView.setText(asset.getType());
            row.addView(typeTextView);

            TextView populationTextView = new TextView(getContext());
            populationTextView.setText(asset.getPopulation());
            row.addView(populationTextView);

            TextView levelTextView = new TextView(getContext());
            levelTextView.setText(asset.getLevel());
            row.addView(levelTextView);

            if(asset.getStation().equals("No Station")){
                Button buyButton = new Button(getContext());
                buyButton.setText(asset.getStation());
                buyButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                        builder.setMessage("Your Stations name");
                        builder.setTitle("Station Name");
                        builder.setCancelable(false);
                        final EditText input = new EditText(getContext());
                        builder.setView(input);
                        builder.setPositiveButton("Yes", (DialogInterface.OnClickListener) (dialog, which) -> {
                            buyButton(asset.getAssetId(), String.valueOf(input.getText()));
                        });

                        AlertDialog alertDialog = builder.create();
                        alertDialog.show();

                    }
                });
                row.addView(buyButton);
                tableLayout.addView(row);
            }else {
                TextView ownerTextView = new TextView(getContext());
                ownerTextView.setText(asset.getStation());
                row.addView(ownerTextView);
                tableLayout.addView(row);
            }
        }
    }

    private void buyButton(int assetId, String name){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        String url = "http://192.168.129.37:3000/station/create";
        //String url = "http://192.168.178.39:3000/station/create";
        JSONObject jsonBody = new JSONObject();
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        try{
            jsonBody.put("assetId", assetId);
            jsonBody.put("name", name);
        } catch (JSONException e) {
            e.printStackTrace();

        }


       StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            String message = jsonResponse.optString("message");
                            apiCall();
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                if (error.networkResponse != null && error.networkResponse.data != null) {
                    try {
                        String errorResponse = new String(error.networkResponse.data, "UTF-8");
                        JSONObject errorJson = new JSONObject(errorResponse);


                        String errorMessage = errorJson.optString("message");
                        System.out.println("Error Message: " + errorMessage);

                        new AlertDialog.Builder(getActivity())
                                .setTitle("Error")
                                .setMessage(errorMessage)
                                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        dialog.dismiss();
                                    }
                                })
                                .show();
                    } catch (UnsupportedEncodingException | JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("Error: " + error.toString());
                }
            }
        }) {
            @Override
            public byte[] getBody() {

                return jsonBody.toString().getBytes();
            }

            @Override
            public String getBodyContentType() {
                return "application/json";
            }


            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> headers = new HashMap<>();
                headers.put("Authorization", token);
                return headers;
            }
        };

        queue.add(stringRequest);
    }


}