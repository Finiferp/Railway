package com.example.railway;

import android.app.AlertDialog;
import android.app.LauncherActivity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import android.os.TestLooperManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.example.railway.databinding.FragmentMyRailwaysBinding;
import com.example.railway.ressources.ConnectedStation;
import com.example.railway.ressources.MyAsset;
import com.example.railway.ressources.MyRailway;
import com.example.railway.ressources.Railway;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class MyRailwaysFragment extends Fragment {

    private FragmentMyRailwaysBinding binding;

    private ArrayList<MyRailway> alMyRailways = new ArrayList<>();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentMyRailwaysBinding.inflate(inflater, container, false);
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

    private void apiCall() {
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        String url = "http://192.168.129.37:3000/player/railways";
        //String url = "http://192.168.178.39:3000/player/railways";
        JSONObject jsonBody = new JSONObject();
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int id = preferences.getInt("id", -1);
        try {
            jsonBody.put("userId", id);
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
                            for (int i = 0; i < data.length(); i++) {
                                JSONObject myRailway = (JSONObject) data.get(i);
                                int stationId = myRailway.optInt("station_id", -1);
                                String stationName = myRailway.optString("station_name");
                                ArrayList<Railway> alRailway = new ArrayList<>();
                                JSONArray railways = myRailway.optJSONArray("railways");
                                if (railways != null) {
                                    for (int j = 0; j < railways.length(); j++) {
                                        JSONObject railway = (JSONObject) railways.get(j);
                                        int distance = railway.optInt("distance", -1);
                                        int railwayId = railway.optInt("railway_id", -1);
                                        ArrayList<ConnectedStation> alConnectedStation = new ArrayList<>();
                                        JSONArray connectedStations = railway.optJSONArray("connected_stations");
                                        if (connectedStations != null) {
                                            for (int k = 0; k < connectedStations.length(); k++) {
                                                JSONObject connectedStation = (JSONObject) connectedStations.get(k);
                                                int assetId = connectedStation.optInt("assetId", -1);
                                                int connectedStationId = connectedStation.optInt("connected_station_id", -1);
                                                String connectedStationName = connectedStation.optString("connected_station_name");
                                                ConnectedStation connectedStation1 = new ConnectedStation(assetId, connectedStationId, connectedStationName);
                                                alConnectedStation.add(connectedStation1);
                                            }
                                            Railway railway1 = new Railway(distance, railwayId, alConnectedStation);
                                            alRailway.add(railway1);
                                        } else {
                                            Railway railway1 = new Railway(distance, railwayId);
                                            alRailway.add(railway1);
                                        }
                                    }
                                    MyRailway myRailway1 = new MyRailway(stationId, stationName, alRailway);
                                    alMyRailways.add(myRailway1);
                                } else {
                                    MyRailway myRailway1 = new MyRailway(stationId, stationName);
                                    alMyRailways.add(myRailway1);
                                }
                            }
                            populate();
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

    private void populate() {
        LinearLayout view = binding.myRailwaysList;

        LinearLayout myRailwayLayout = new LinearLayout(requireContext());
        myRailwayLayout.setOrientation(LinearLayout.VERTICAL);
        myRailwayLayout.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
        ));


        for(MyRailway myRailway : alMyRailways) {
            System.out.println(myRailway.getStationName());
            TextView myRailwayName = new TextView(requireContext());
            myRailwayName.setText("Station: " + myRailway.getStationName()+"");
            myRailwayLayout.addView(myRailwayName);


            if(!myRailway.getAlRailways().isEmpty()) {
                LinearLayout railwayLayout = new LinearLayout(requireContext());
                railwayLayout.setOrientation(LinearLayout.VERTICAL);
                railwayLayout.setLayoutParams(new LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.MATCH_PARENT
                ));

                LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) railwayLayout.getLayoutParams();
                layoutParams.setMargins(100, 0, 0, 0);
                railwayLayout.setLayoutParams(layoutParams);

                ArrayList<Railway> alRailway = myRailway.getAlRailways();
                for (int j = 0; j < alRailway.size(); j++) {
                    TextView distance = new TextView(getContext());
                    distance.setText("Length of the Railway: " + alRailway.get(j).getDistance());
                    railwayLayout.addView(distance);

                    LinearLayout station = new LinearLayout(requireContext());
                    station.setOrientation(LinearLayout.VERTICAL);
                    station.setLayoutParams(new LinearLayout.LayoutParams(
                            LinearLayout.LayoutParams.MATCH_PARENT,
                            LinearLayout.LayoutParams.MATCH_PARENT
                    ));

                    LinearLayout.LayoutParams layoutParams2 = (LinearLayout.LayoutParams) station.getLayoutParams();
                    layoutParams2.setMargins(100, 0, 0, 0);
                    station.setLayoutParams(layoutParams2);
                    TextView text = new TextView(getContext());
                    text.setText("Connects Station: ");
                    station.addView(text);


                    ArrayList<ConnectedStation> alConnectedStation = alRailway.get(j).getAlConnectedStations();
                    for (int k = 0; k < alConnectedStation.size(); k++) {
                        TextView stationName = new TextView(getContext());
                        stationName.setText("- " + alConnectedStation.get(k).getConnectedStationName());
                        station.addView(stationName);
                    }
                    railwayLayout.addView(station);
                }
                Button buyButton = new Button(getContext());
                buyButton.setText("Add Railway");
                buyButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                        builder.setMessage("Please enter the name of the destination Station!");
                        builder.setTitle("Station Name");
                        builder.setCancelable(false);
                        final EditText input = new EditText(getContext());
                        builder.setView(input);
                        builder.setPositiveButton("Yes", (DialogInterface.OnClickListener) (dialog, which) -> {
                            getStation(myRailway.getStationId(), String.valueOf(input.getText()));
                        });

                        AlertDialog alertDialog = builder.create();
                        alertDialog.show();
                    }
                });
                myRailwayLayout.addView(railwayLayout);
                myRailwayLayout.addView(buyButton);
            }else{
                Button buyButton = new Button(getContext());
                buyButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                        builder.setMessage("Please enter the name of the destination Station!");
                        builder.setTitle("Station Name");
                        builder.setCancelable(false);
                        final EditText input = new EditText(getContext());
                        builder.setView(input);
                        builder.setPositiveButton("Yes", (DialogInterface.OnClickListener) (dialog, which) -> {
                            getStation(myRailway.getStationId(), String.valueOf(input.getText()));
                        });

                        AlertDialog alertDialog = builder.create();
                        alertDialog.show();
                    }
                });
                buyButton.setText("Add Railway");
                myRailwayLayout.addView(buyButton);
            }
        }


        view.addView(myRailwayLayout);
        TextView textView = new TextView(requireContext());
        textView.setText("Keep in mind maximum 10 Railways per station");
        view.addView(textView);
    }


    private void getStation(int station1Id, String name) {
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        String url = "http://192.168.129.37:3000/station/name";
        //String url = "http://192.168.178.39:3000/station/name";
        JSONObject jsonBody = new JSONObject();
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        try {
            jsonBody.put("station_name", name);
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
                            int station2Id = data.getInt("id");
                            buy(station1Id, station2Id);
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



    private void buy(int station1Id, int station2Id) {
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        String url = "http://192.168.129.37:3000/railway/create";
        //String url = "http://192.168.178.39:3000/railway/create";
        JSONObject jsonBody = new JSONObject();
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int userId = preferences.getInt("id", -1);
        try {
            jsonBody.put("station1Id", station1Id);
            jsonBody.put("station2Id", station2Id);
            jsonBody.put("userId", userId);
            System.out.println(jsonBody);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                           // JSONArray data = jsonResponse.optJSONArray("data");
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