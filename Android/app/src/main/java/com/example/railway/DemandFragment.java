package com.example.railway;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
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
import com.example.railway.databinding.FragmentDemandBinding;
import com.example.railway.ressources.Asset;
import com.example.railway.ressources.Good;
import com.example.railway.ressources.MyIndustry;
import com.example.railway.ressources.MyNeed;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DemandFragment extends Fragment {
    private ArrayList<Asset> alBusinesses = new ArrayList<>();
    private ArrayList<Asset> alTowns = new ArrayList<>();
    private ArrayList<Good> alGoods = new ArrayList<>();
    private FragmentDemandBinding binding;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentDemandBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        apiCall();
    }

    private void apiCall(){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int id = preferences.getInt("id", -1);
        int worldId = preferences.getInt("idWorld", -1);

        String url = "http://192.168.129.37:3000/asset/world/"+worldId;
        //String url = "http://192.168.178.39:3000/asset/world/"+worldId;

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONArray data = jsonResponse.optJSONArray("data");
                            for (int i = 0; i < data.length(); i++) {
                                JSONObject asset = (JSONObject) data.get(i);
                                String business = asset.getString("type");
                                String name = asset.getString("name");;
                                int id = asset.getInt("idAsset_PK");
                                if(business.equals("RURALBUSINESS")){
                                    Asset asset1 = new Asset(name,id);
                                    alBusinesses.add(asset1);
                                }
                            }
                            nextApiCall();
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

    private void nextApiCall(){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int id = preferences.getInt("id", -1);
        int worldId = preferences.getInt("idWorld", -1);

        String url = "http://192.168.129.37:3000/asset/player/"+id;
        //String url = "http://192.168.178.39:3000/asset/player/"+id;

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONArray data = jsonResponse.optJSONArray("data");
                            for (int i = 0; i < data.length(); i++) {
                                JSONObject asset = (JSONObject) data.get(i);
                                String business = asset.getString("type");
                                String name = asset.getString("name");;
                                int id = asset.getInt("assetId");
                                if(business.equals("TOWN")){
                                    Asset asset1 = new Asset(name, id);
                                    alTowns.add(asset1);
                                }
                            }
                            afterNextApiCall();

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

    private void afterNextApiCall(){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int id = preferences.getInt("id", -1);
        int worldId = preferences.getInt("idWorld", -1);

        String url = "http://192.168.129.37:3000/goods";
        //String url = "http://192.168.178.39:3000/goods";

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONArray data = jsonResponse.optJSONArray("data");
                            for (int i = 0; i < data.length(); i++) {
                                JSONObject asset = (JSONObject) data.get(i);
                                String name = asset.getString("name");
                                int id = asset.getInt("id");

                                Good good = new Good(name, id);
                                alGoods.add(good);
                            }
                            populate();

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


    private void populate() {
        Spinner businessSpinner = binding.businessNameSpinner;
        List<String> businesses=new ArrayList<>();
        for(Asset asset : alBusinesses) {
            businesses.add(asset.getName());
        }

        ArrayAdapter<String> businessSpinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, businesses);
        businessSpinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        businessSpinner.setAdapter(businessSpinnerAdapter);


        Spinner townsSpinner = binding.townNameSpinner;
        List<String> towns=new ArrayList<>();
        for(Asset asset : alTowns) {
            towns.add(asset.getName());
        }

        ArrayAdapter<String> townsSpinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, towns);
        townsSpinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        townsSpinner.setAdapter(townsSpinnerAdapter);


        Spinner goodsSpinner = binding.goodNameSpinner;
        List<String> goods=new ArrayList<>();
        for(Good good : alGoods) {
            goods.add(good.getName());
        }

        ArrayAdapter<String> goodsSpinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, goods);
        goodsSpinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        goodsSpinner.setAdapter(goodsSpinnerAdapter);

        ArrayList <Integer> alNumbers = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            alNumbers.add(i);
        }

        Spinner number = binding.amountSpinner;
        ArrayAdapter<Integer> numberSpinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, alNumbers);
        numberSpinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        number.setAdapter(numberSpinnerAdapter);

        Button doneButton =  binding.doneButton2;

        doneButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               int businessSelected = (int)businessSpinner.getSelectedItemId();
               int townSelected = (int)townsSpinner.getSelectedItemId();
               int goodSelected = (int)goodsSpinner.getSelectedItemId();

               int businessId = alBusinesses.get(businessSelected).getId();
               int townId = alTowns.get(townSelected).getId();
               int goodId = alGoods.get(goodSelected).getId();
               int amount = (int) number.getSelectedItem();

               demand(businessId,townId, goodId,amount);

            }
        });
    }



    private void demand(int businessId, int townId, int goodId, int amount) {
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int userId = preferences.getInt("id",-1);
        String url = "http://192.168.129.37:3000/player/railways";
        //String url = "http://192.168.178.39:3000/player/railways";
        JSONObject jsonBody = new JSONObject();

        try {
            jsonBody.put("userId",userId);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONArray data = jsonResponse.optJSONArray("data");
                            int railwayId = -1;
                            for(int i = 0; i < data.length(); i++) {
                                JSONObject railwaysData = data.getJSONObject(i);
                                JSONArray railways = railwaysData.optJSONArray("railways");
                                for(int j = 0; j < railways.length(); j++) {
                                    JSONObject railway = railways.getJSONObject(j);
                                    JSONArray stations = railway.optJSONArray("connected_stations");
                                    if(stations.length() == 2) {
                                        JSONObject firstStation = stations.getJSONObject(0);
                                        JSONObject secondStation = stations.getJSONObject(1);
                                        int firstId = firstStation.getInt("assetId");
                                        int secondId = secondStation.getInt("assetId");
                                        if((firstId == townId || firstId == businessId)
                                            && (secondId == townId || secondId == businessId)){
                                            railwayId = railway.getInt("railway_id");
                                        }
                                    }
                                }
                            }
                            if(railwayId != -1){
                                System.out.println("yay");
                                lastApiCall(businessId,townId,goodId,amount,railwayId);
                            } else {
                                System.out.println("error");
                                AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                                builder.setMessage("No railway between the two is established!");
                                builder.setTitle("Error!");
                                final EditText input = new EditText(getContext());
                                builder.setView(input);
                                builder.setPositiveButton("Yes", (DialogInterface.OnClickListener) (dialog, which) -> {
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

    private void lastApiCall(int businessId, int townId, int goodId, int amount, int railway){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        String url = "http://192.168.129.37:3000/train/demand";
        //String url = "http://192.168.178.39:3000/train/demand";
        JSONObject jsonBody = new JSONObject();

        try {
            jsonBody.put("assetFromId",businessId);
            jsonBody.put("assetToId",townId);
            jsonBody.put("railwayId",railway);
            jsonBody.put("goodId",goodId);
            jsonBody.put("amount",amount);

        } catch (JSONException e) {
            e.printStackTrace();
        }

        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONArray data = jsonResponse.optJSONArray("data");
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

}