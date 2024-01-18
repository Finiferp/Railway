package com.example.railway.ressources;

public class MyAsset {

    private String name, type, population, level, station, assetId;

    public MyAsset(String name, String type, String population, String level, String station, String assetId) {
        this.name = name;
        this.type = type;
        this.population = population;
        this.level = level;
        this.station = station;
        this.assetId = assetId;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public String getPopulation() {
        return population;
    }

    public String getLevel() {
        return level;
    }

    public String getStation() {
        return station;
    }

    public String getAssetId() {
        return assetId;
    }
}
