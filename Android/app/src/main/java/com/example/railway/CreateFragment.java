package com.example.railway;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Switch;
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
import com.example.railway.databinding.FragmentCreateBinding;
import com.example.railway.ressources.Good;
import com.example.railway.ressources.MyIndustry;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class CreateFragment extends Fragment {

    private FragmentCreateBinding binding;

    private String destinationName;
    private int selectedRailwayId;
    private String startName;


    ArrayList<String> alConnectedStationNames = new ArrayList<>();
    ArrayList<JSONObject> alRailways = new ArrayList<>();


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentCreateBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        binding.doneCreateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                createTrain();
            }
        });
        loadRailways();
    }


    private void loadRailways(){
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
                            for(int i = 0; i < data.length(); i++) {
                                JSONObject railway = (JSONObject) data.get(i);
                                alRailways.add(railway);
                            }
                            buildRailways();

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

    private void buildRailways() throws JSONException {
        Spinner stationSpinner = binding.stationSpinner;
        List<String> stationNames=new ArrayList<>();

        for(int i = 0; i < alRailways.size(); i++) {
            JSONObject railway = alRailways.get(i);
            alConnectedStationNames = new ArrayList<>();
            String stationName = railway.getString("station_name");
            startName = stationName;
            stationNames.add(stationName);

        }

        ArrayAdapter<String> stationsSpinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, stationNames);
        stationsSpinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        stationSpinner.setAdapter(stationsSpinnerAdapter);

        stationSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
                int selectedId = (int) stationSpinner.getSelectedItemId();
                JSONObject railway = alRailways.get(selectedId);
                try {
                    int stationId = railway.getInt("station_id");
                    JSONArray stations = railway.getJSONArray("railways");

                    for(int i = 0; i < stations.length(); i++){
                        JSONObject station = (JSONObject) stations.get(i);
                        selectedRailwayId = station.getInt("railway_id");
                        JSONArray connectedStations = station.getJSONArray("connected_stations");

                        for(int j = 0; j < connectedStations.length(); j++){
                            JSONObject connectedStation = (JSONObject) connectedStations.get(j);
                            int destination = connectedStation.getInt("connected_station_id");
                            if(destination != stationId){
                                String stationName = connectedStation.getString("connected_station_name");
                                if( !alConnectedStationNames.contains(stationName)){
                                    alConnectedStationNames.add(stationName);
                                }
                            }

                        }
                    }

                    loadstations();
                } catch (JSONException e) {
                    throw new RuntimeException(e);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parentView) {
                System.out.println("Never printed");
            }

        });
    }

    private void loadstations(){
        Spinner destinationSpinner = binding.destinationSpinner;

        ArrayAdapter<String> destinationSpinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, alConnectedStationNames);
        destinationSpinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        destinationSpinner.setAdapter(destinationSpinnerAdapter);

        destinationSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
                destinationName = (String) destinationSpinner.getSelectedItem();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parentView) {
                System.out.println("Never printed");
            }

        });
    }
    int station1Id = -1;
    int station2Id = -1;

    private void createTrain(){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int userId = preferences.getInt("id",-1);
        String url = "http://192.168.129.37:3000/station/name";
        //String url = "http://192.168.178.39:3000/station/name";
        JSONObject jsonBody = new JSONObject();

        try {
            jsonBody.put("station_name",startName);
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
                            station1Id = data.getInt("idAsset_FK");

                            getSecondStation();
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

    private void getSecondStation(){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int userId = preferences.getInt("id",-1);
        String url = "http://192.168.129.37:3000/station/name";
        //String url = "http://192.168.178.39:3000/station/name";
        JSONObject jsonBody = new JSONObject();

        try {
            jsonBody.put("station_name",destinationName);
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
                            station2Id = data.getInt("idAsset_FK");

                            finalCreate();
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

    private void finalCreate(){
        RequestQueue queue = Volley.newRequestQueue(requireContext());
        Switch returnSwitch = binding.returnSwitch;
        EditText plainText = binding.trainsNameText;
        SharedPreferences preferences = requireContext().getSharedPreferences("MyPrefs", Context.MODE_PRIVATE);
        String token = preferences.getString("token", "");
        int userId = preferences.getInt("id",-1);
        String url = "http://192.168.129.37:3000/train/create";
        //String url = "http://192.168.178.39:3000/train/create";
        JSONObject jsonBody = new JSONObject();

        try {
            jsonBody.put("name", plainText.getText());
            jsonBody.put("idRailway", selectedRailwayId);
            jsonBody.put("idAsset_Starts", station1Id);
            jsonBody.put("idAsset_Destines", station2Id);
            jsonBody.put("willReturnWithGoods",returnSwitch.isChecked());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        System.out.println(jsonBody);
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonResponse = new JSONObject(response);
                            JSONObject data = jsonResponse.optJSONObject("data");
                            station2Id = data.getInt("idAsset_FK");

                            finalCreate();
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