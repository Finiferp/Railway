package com.example.railway;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
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
import com.example.railway.databinding.FragmentAssetsBinding;
import com.example.railway.databinding.FragmentMyAssetsBinding;
import com.example.railway.ressources.MyAsset;
import com.example.railway.ressources.WorldsAsset;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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
                                int assetId = asset.getInt("idAsset_PK");
                                /*if(ownerId != 0) {
                                    getPlayerName(ownerId, new AssetsFragment.PlayerNameCallback() {
                                        @Override
                                        public void onPlayerNameReceived(String ownerName) {
                                            WorldsAsset worldsAsset = new WorldsAsset(name, type, position, population, level, goods, ownerName,assetId);
                                            alAssets.add(worldsAsset);
                                            if (alAssets.size() == data.length()) {
                                                populate();
                                            }
                                        }
                                    });
                                }else {
                                    WorldsAsset worldsAsset = new WorldsAsset(name, type, position, population, level, goods, "None",assetId);
                                    alAssets.add(worldsAsset);
                                    if (alAssets.size() == data.length()) {
                                        populate();
                                    }
                                }*/
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
    private void getPlayerName(int id, MyAssetsFragment.StationCallback callback){

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
                            System.out.println(data);
                            callback.onStationReceived("as");
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
    }
}