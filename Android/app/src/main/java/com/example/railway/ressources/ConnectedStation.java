package com.example.railway.ressources;

public class ConnectedStation {
    private int assetId,connectedStationId;
    private String connectedStationName;

    public ConnectedStation(int assetId, int connectedStationId, String connectedStationName) {
        this.assetId = assetId;
        this.connectedStationId = connectedStationId;
        this.connectedStationName = connectedStationName;
    }

    public int getAssetId() {
        return assetId;
    }

    public int getConnectedStationId() {
        return connectedStationId;
    }

    public String getConnectedStationName() {
        return connectedStationName;
    }
}
