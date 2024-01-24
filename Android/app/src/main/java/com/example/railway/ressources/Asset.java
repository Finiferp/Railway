package com.example.railway.ressources;

public class Asset {
    private String name;
    private int id;

    public Asset(String name, int id) {
        this.name = name;
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }
}
