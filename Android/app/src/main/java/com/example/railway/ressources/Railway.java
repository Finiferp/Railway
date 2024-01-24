package com.example.railway.ressources;

import java.util.ArrayList;

public class Railway {
    private int distance, railwayId;
    private ArrayList<ConnectedStation> alConnectedStations = new ArrayList<>();

    public Railway(int distance, int railwayId, ArrayList<ConnectedStation> alConnectedStations) {
        this.distance = distance;
        this.railwayId = railwayId;
        this.alConnectedStations = alConnectedStations;
    }

    public Railway(int distance, int railwayId) {
        this.distance = distance;
        this.railwayId = railwayId;
    }

    public int getDistance() {
        return distance;
    }

    public int getRailwayId() {
        return railwayId;
    }

    public ArrayList<ConnectedStation> getAlConnectedStations() {
        return alConnectedStations;
    }
}
