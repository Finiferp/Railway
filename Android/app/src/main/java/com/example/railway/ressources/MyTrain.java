package com.example.railway.ressources;

public class MyTrain {
    private String name, cost, isReturining, operationalCost, distance, startingAsset, destinationAsset, willReturnWithGoods, good;
    private int id;

    public MyTrain(String name, String cost, String isReturining, String operationalCost,
                   String distance, String startingAsset, String destinationAsset, String willReturnWithGoods, String good, int id) {
        this.name = name;
        this.cost = cost;
        this.isReturining = isReturining;
        this.operationalCost = operationalCost;
        this.distance = distance;
        this.startingAsset = startingAsset;
        this.destinationAsset = destinationAsset;
        this.willReturnWithGoods = willReturnWithGoods;
        this.good = good;
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public String getCost() {
        return cost;
    }

    public String getIsReturining() {
        return isReturining;
    }

    public String getOperationalCost() {
        return operationalCost;
    }

    public String getDistance() {
        return distance;
    }

    public String getStartingAsset() {
        return startingAsset;
    }

    public String getDestinationAsset() {
        return destinationAsset;
    }

    public String getWillReturnWithGoods() {
        return willReturnWithGoods;
    }

    public String getGood() {
        return good;
    }

    public int getId() {
        return id;
    }
}
