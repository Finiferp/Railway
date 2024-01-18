package com.example.railway;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.navigation.fragment.NavHostFragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
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
import com.example.railway.ressources.WorldsAsset;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class AssetsFragment extends Fragment {
    private final String[] assetsHeaders = {"Name","Type","Position","Population","Level","Goods","Owner"};
    private ArrayList<WorldsAsset> alAssets = new ArrayList<>();
    private FragmentAssetsBinding binding;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentAssetsBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

   private void populate(){

        TableLayout tableLayout = binding.worldAssetsTable;
        tableLayout.removeAllViews();
        TableRow headersRow = new TableRow(getContext());

        for(int i = 0 ; i<assetsHeaders.length;i++){
            TextView temp = new TextView(getContext());
            temp.setText(assetsHeaders[i]);
            headersRow.addView(temp);
        }
        tableLayout.addView(headersRow);

       for (WorldsAsset asset : alAssets) {
           TableRow row = new TableRow(getContext());

           TextView nameTextView = new TextView(getContext());
           nameTextView.setText(asset.getName());
           row.addView(nameTextView);

           TextView typeTextView = new TextView(getContext());
           typeTextView.setText(asset.getType());
           row.addView(typeTextView);

           TextView positionTextView = new TextView(getContext());
           positionTextView.setText(asset.getPosition());
           row.addView(positionTextView);

           TextView populationTextView = new TextView(getContext());
           populationTextView.setText(asset.getPopulation());
           row.addView(populationTextView);

           TextView levelTextView = new TextView(getContext());
           levelTextView.setText(asset.getLevel());
           row.addView(levelTextView);

           TextView goodsTextView = new TextView(getContext());
           goodsTextView.setText(asset.getGoods());
           row.addView(goodsTextView);

           if(asset.getOwner().equals("None")){
               Button buyButton = new Button(getContext());
               buyButton.setText(asset.getOwner());
               buyButton.setOnClickListener(new View.OnClickListener() {
                   @Override
                   public void onClick(View v) {
                       buyButton(asset.getId());
                   }
               });
               row.addView(buyButton);
               tableLayout.addView(row);
           }else {
               TextView ownerTextView = new TextView(getContext());
               ownerTextView.setText(asset.getOwner());
               row.addView(ownerTextView);
               tableLayout.addView(row);
           }
       }
    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        apiCall();
        //populate();
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
        String username = preferences.getString("username", "");
        int worldId = preferences.getInt("idWorld",-1);

        String url = "http://192.168.129.37:3000/asset/world/"+worldId;
        //String url = "http://192.168.178.39:3000/asset/world/"+worldId;

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONArray data = jsonResponse.optJSONArray("data");
                            for(int i = 0; i< data.length();i++){
                                JSONObject asset = (JSONObject) data.get(i);
                                String name = asset.getString("name");
                                String type = asset.getString("type");
                                String position = asset.getString("position");
                                String population = asset.getString("population");
                                String level = asset.getString("level");
                                String goods = asset.optString("goods");
                                int assetId = asset.getInt("idAsset_PK");
                                int ownerId = asset.optInt("idOwner_FK");
                                if(ownerId != 0) {
                                    getPlayerName(ownerId, new PlayerNameCallback() {
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
                                }
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


    private interface PlayerNameCallback {
        void onPlayerNameReceived(String playerName);
    }
    private void getPlayerName(int id,PlayerNameCallback callback){

        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");

        String url = "http://192.168.129.37:3000/player/"+id;
        //String url = "http://192.168.178.39:3000/player/"+id;

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONObject data = jsonResponse.optJSONObject("data");
                            String name = data.getString("username");
                            callback.onPlayerNameReceived(name);
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


    private void buyButton(int assetId){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        String url = "http://192.168.129.37:3000/asset/buy";
        //String url = "http://192.168.178.39:3000/asset/buy";
        JSONObject jsonBody = new JSONObject();
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int id = preferences.getInt("id", -1);
        try{
            jsonBody.put("userId", id);
            jsonBody.put("assetId", assetId);
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
        }

        ;

        queue.add(stringRequest);
    }

}