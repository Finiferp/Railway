package com.example.railway.ressources;

import java.util.ArrayList;

public class MyRailway {
    private int stationId;
    private String stationName;
    private ArrayList<Railway> alRailways = new ArrayList<>();

    public MyRailway(int stationId, String stationName, ArrayList<Railway> alRailways) {
        this.stationId = stationId;
        this.stationName = stationName;
        this.alRailways = alRailways;
    }

    public MyRailway(int stationId, String stationName) {
        this.stationId = stationId;
        this.stationName = stationName;
    }

    public int getStationId() {
        return stationId;
    }

    public String getStationName() {
        return stationName;
    }

    public ArrayList<Railway> getAlRailways() {
        return alRailways;
    }
}

