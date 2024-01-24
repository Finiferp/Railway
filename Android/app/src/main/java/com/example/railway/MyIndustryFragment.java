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
import com.example.railway.ressources.MyIndustry;
import com.example.railway.ressources.MyNeed;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class MyIndustryFragment extends Fragment {
    private final String[] industriesHeaders = {"Asset: "};
    private ArrayList<MyIndustry> alMyIndustries = new ArrayList<>();

    private FragmentMyIndustryBinding binding;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentMyIndustryBinding.inflate(inflater, container, false);
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
        String url = "http://192.168.129.37:3000/player/industries";
        //String url = "http://192.168.178.39:3000/player/industries";
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
                                JSONObject industry = (JSONObject) data.get(i);
                                String assetName = industry.getString("asset_name");
                                int assetId = industry.getInt("asset_id");
                                JSONArray industries = industry.optJSONArray("industries");
                                if(industries != null) {
                                    TableLayout industriesText = new TableLayout(getContext());
                                    TableRow headersRow = new TableRow(getContext());
                                    TableRow headersRow0 = new TableRow(getContext());

                                    TextView nameTextView0 = new TextView(getContext());
                                    nameTextView0.setText("Industries: ");
                                    headersRow0.addView(nameTextView0);

                                    industriesText.addView(headersRow0);

                                    TextView blankTextView = new TextView(getContext());
                                    blankTextView.setText("\t\t\t\t\t");
                                    headersRow.addView(blankTextView);

                                    TextView nameTextView1 = new TextView(getContext());
                                    nameTextView1.setText("Industry Name: ");
                                    headersRow.addView(nameTextView1);

                                    TextView nameTextView2 = new TextView(getContext());
                                    nameTextView2.setText("Industry Type: ");
                                    headersRow.addView(nameTextView2);

                                    TextView nameTextView3 = new TextView(getContext());
                                    nameTextView3.setText("Produced Good Name: ");
                                    headersRow.addView(nameTextView3);

                                    TextView nameTextView4 = new TextView(getContext());
                                    nameTextView4.setText("Warehouse Capacity: ");
                                    headersRow.addView(nameTextView4);

                                    industriesText.addView(headersRow);

                                    for (int j = 0; j < industries.length(); j++) {
                                        TableRow row = new TableRow(getContext());

                                        JSONObject item = industries.optJSONObject(j);
                                        if (item != null) {
                                            String name = item.getString("industry_name");
                                            String type = item.getString("industry_type");
                                            String goodName = item.getString("produced_good_name");
                                            String capacity = item.getString("warehouse_capacity");

                                            TextView blankTextView1 = new TextView(getContext());
                                            blankTextView1.setText("\t\t\t\t\t");
                                            row.addView(blankTextView1);

                                            TextView nameTextView = new TextView(getContext());
                                            nameTextView.setText(name);
                                            row.addView(nameTextView);

                                            TextView typeTextView = new TextView(getContext());
                                            typeTextView.setText(type);
                                            row.addView(typeTextView);

                                            TextView goodNameTextView = new TextView(getContext());
                                            goodNameTextView.setText(goodName);
                                            row.addView(goodNameTextView);

                                            TextView capacityTextView = new TextView(getContext());
                                            capacityTextView.setText(capacity);
                                            row.addView(capacityTextView);

                                            industriesText.addView(row);
                                        }
                                    }
                                    MyIndustry myIndustry = new MyIndustry(assetName, industriesText, assetId);
                                    alMyIndustries.add(myIndustry);
                                }
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
        TableLayout tableLayout = binding.myIndustriesTableLayout;
        tableLayout.removeAllViews();
        tableLayout.invalidate();

        TableRow headersRow = new TableRow(getContext());
        for (int i = 0; i < industriesHeaders.length; i++) {
            TextView temp = new TextView(getContext());
            temp.setText(industriesHeaders[i]);
            headersRow.addView(temp);
        }
        tableLayout.addView(headersRow);

        for(MyIndustry industry : alMyIndustries){
            TableRow row = new TableRow(getContext());

            TextView nameTextView = new TextView(getContext());
            nameTextView.setText(industry.getName());
            row.addView(nameTextView);



            tableLayout.addView(row);


            TableLayout industries = industry.getIndustries();

            tableLayout.addView(industries);



            TableRow rowBuy = new TableRow(getContext());
            Spinner spinner = new Spinner(getContext());

            List<String> items = new ArrayList<>();
            items.add("BREWERY");
            items.add("BUTCHER");
            items.add("BAKERY");
            items.add("SAWMILL");
            items.add("CHEESEMAKER");
            items.add("CARPENTER");
            items.add("TAILOR");
            items.add("SMELTER");
            items.add("SMITHY");
            items.add("JEWELER");

            ArrayAdapter<String> spinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, items);
            spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spinner.setAdapter(spinnerAdapter);

            Button buyButton = new Button(getContext());
            buyButton.setText("Buy a new Industry");
            buyButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    String type = spinner.getSelectedItem().toString();
                    int idAsset = industry.getAssetId();

                    AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                    builder.setMessage("Your Inudstry´s name");
                    builder.setTitle("Industry Name");
                    builder.setCancelable(false);
                    final EditText input = new EditText(getContext());
                    builder.setView(input);
                    builder.setPositiveButton("Yes", (DialogInterface.OnClickListener) (dialog, which) -> {
                        buyButton(idAsset, String.valueOf(input.getText()), type);
                    });

                    AlertDialog alertDialog = builder.create();
                    alertDialog.show();

                }
            });

            rowBuy.addView(buyButton);
            rowBuy.addView(spinner);
            tableLayout.addView(rowBuy);

        }

    }



    private void buyButton(int assetId, String name, String type){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        String url = "http://192.168.129.37:3000/industry/create";
        //String url = "http://192.168.178.39:3000/industry/create";
        JSONObject jsonBody = new JSONObject();
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        try{
            jsonBody.put("idAsset", assetId);
            jsonBody.put("name", name);
            jsonBody.put("type", type);
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