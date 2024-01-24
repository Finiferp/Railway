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
import com.example.railway.databinding.FragmentMyStockpileBinding;
import com.example.railway.ressources.MyNeed;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class MyStockpileFragment extends Fragment {
    private final String[] assetsHeaders = {"Asset Name \t","Asset id \t","Good \t"};
    private ArrayList<MyNeed> alMyNeeds = new ArrayList<>();

    private FragmentMyStockpileBinding binding;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentMyStockpileBinding.inflate(inflater, container, false);
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
        int userId = preferences.getInt("id",-1);
        String url = "http://192.168.129.37:3000/player/stockpile";
        //String url = "http://192.168.178.39:3000/player/stockpile";

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
                            for(int i = 0; i< data.length();i++){
                                JSONObject need = (JSONObject) data.get(i);
                                String assetName = need.getString("asset_name");
                                String assetId = need.getString("asset_id");
                                JSONArray goods = need.getJSONArray("goods");
                                String needs = "";
                                for(int j = 0; j< goods.length(); j++){
                                    JSONObject item = goods.getJSONObject(i);
                                    String goodName = item.getString("good_name");
                                    double quantity = item.getDouble("quantity");
                                    needs += goodName + ": " + quantity + ("\r\n");
                                }
                                MyNeed myNeed = new MyNeed(assetName,assetId,needs);
                                alMyNeeds.add(myNeed);
                                populate();
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


    private void populate() {

        TableLayout tableLayout = binding.myStockpileTableLayout;
        tableLayout.removeAllViews();
        TableRow headersRow = new TableRow(getContext());

        for (int i = 0; i < assetsHeaders.length; i++) {
            TextView temp = new TextView(getContext());
            temp.setText(assetsHeaders[i]);
            headersRow.addView(temp);
        }
        tableLayout.addView(headersRow);

        for(MyNeed need : alMyNeeds){
            TableRow row = new TableRow(getContext());

            TextView nameTextView = new TextView(getContext());
            nameTextView.setText(need.getAssetName());
            row.addView(nameTextView);

            TextView typeTextView = new TextView(getContext());
            typeTextView.setText(need.getAssetId());
            row.addView(typeTextView);

            TextView ownerTextView = new TextView(getContext());
            ownerTextView.setText(need.getGood());
            row.addView(ownerTextView);
            tableLayout.addView(row);

        }
    }
}