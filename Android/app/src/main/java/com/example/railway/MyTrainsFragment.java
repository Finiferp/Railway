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
import com.example.railway.databinding.FragmentMyIndustryBinding;
import com.example.railway.databinding.FragmentMyTrainsBinding;
import com.example.railway.ressources.MyIndustry;
import com.example.railway.ressources.MyTrain;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MyTrainsFragment extends Fragment {
    private final String[] myTrainHeaders = {"Name: \t", "Cost: \t", "Is Returning: \t", "Operational Cost: \t",
            "Traveled Distance: \t", "Starting Asset: \t", "Destination Asset: \t",
            "Will Return With Goods: ", "Goods: ", "Delete"};

    private ArrayList<MyTrain> alMyTrains = new ArrayList<>();

    private FragmentMyTrainsBinding binding;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentMyTrainsBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        apiCall();
    }

    private void apiCall() {

        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int userId = preferences.getInt("id",-1);
        String url = "http://192.168.129.37:3000/player/trains";
        //String url = "http://192.168.178.39:3000/player/trains";
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
                            for(int i = 0; i< data.length();i++) {
                                JSONObject train = (JSONObject) data.get(i);
                                String name = train.getString("name");
                                String cost = train.getString("cost");
                                int isReturning = train.getInt("isReturning");
                                String isReturningString = isReturning == 1 ? "Yes" : "NO";
                                String operationalCost = train.getString("operationalCost");
                                String traveledDistance = train.getString("traveledDistance");
                                String idAssetStarts = train.getString("idAsset_Starts_FK");
                                String idAssetDestines = train.getString("idAsset_Destines_FK");
                                int willReturnWithGoods = train.getInt("willReturnWithGoods");
                                String willReturnWithGoodsString = willReturnWithGoods == 1 ? "Yes" : "No";
                                String goodsString = "";
                                int id = train.getInt("id");
                                JSONArray goods = train.optJSONArray("goodsTransported");
                                for(int j = 0; j < goods.length(); j++) {
                                    JSONObject good = (JSONObject) goods.get(j);
                                    goodsString += good.getString("idname") + ": " +
                                            good.getString("amount")  + "\n\r";
                                }
                                MyTrain myTrain = new MyTrain(name,cost,isReturningString,
                                        operationalCost,traveledDistance,idAssetStarts,idAssetDestines,
                                        willReturnWithGoodsString, goodsString, id);
                                alMyTrains.add(myTrain);
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
        TableLayout tableLayout = binding.MyTrainsTableLayout;
        tableLayout.removeAllViews();

        TableRow headersRow = new TableRow(getContext());
        for (int i = 0; i < myTrainHeaders.length; i++) {
            TextView temp = new TextView(getContext());
            temp.setText(myTrainHeaders[i]);
            headersRow.addView(temp);
        }
        tableLayout.addView(headersRow);

        for(MyTrain train : alMyTrains){
            TableRow row = new TableRow(getContext());

            TextView nameTextView = new TextView(getContext());
            nameTextView.setText(train.getName());
            row.addView(nameTextView);

            TextView costTextView = new TextView(getContext());
            costTextView.setText(train.getCost());
            row.addView(costTextView);

            TextView returningTextView = new TextView(getContext());
            returningTextView.setText(train.getIsReturining());
            row.addView(returningTextView);

            TextView operationalCostTextView = new TextView(getContext());
            operationalCostTextView.setText(train.getOperationalCost());
            row.addView(operationalCostTextView);

            TextView distanceTextView = new TextView(getContext());
            distanceTextView.setText(train.getDistance());
            row.addView(distanceTextView);

            TextView startingTextView = new TextView(getContext());
            startingTextView.setText(train.getStartingAsset());
            row.addView(startingTextView);

            TextView endsTextView = new TextView(getContext());
            endsTextView.setText(train.getDestinationAsset());
            row.addView(endsTextView);

            TextView willReturnTextView = new TextView(getContext());
            willReturnTextView.setText(train.getWillReturnWithGoods());
            row.addView(willReturnTextView);

            TextView goodsTextView = new TextView(getContext());
            goodsTextView.setText(train.getGood());
            row.addView(goodsTextView);

            Button deleteButton = new Button(getContext());
            deleteButton.setText("Delete");
            row.addView(deleteButton);

            deleteButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                    builder.setMessage("You really want to delete the train?");
                    builder.setTitle("Are you sure?");
                    builder.setPositiveButton("Yes", (DialogInterface.OnClickListener) (dialog, which) -> {
                        delete(train.getId());
                    });
                    builder.setNegativeButton("No", (DialogInterface.OnClickListener) (dialog, which) -> {
                        System.out.println("Cancelled");
                    });
                    AlertDialog alertDialog = builder.create();
                    alertDialog.show();

                }
            });


            tableLayout.addView(row);
        }

    }

    private void delete(int id){

        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int userId = preferences.getInt("id",-1);
        String url = "http://192.168.129.37:3000/train/delete";
        //String url = "http://192.168.178.39:3000/train/delete";
        JSONObject jsonBody = new JSONObject();

        try {
            jsonBody.put("userId",userId);
            jsonBody.put("trainId",id);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
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