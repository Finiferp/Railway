package com.example.railway.ressources;

import androidx.annotation.NonNull;

public class Good {
    private String name;
    private int id;

    public Good(String name, int id) {
        this.name = name;
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }

    @NonNull
    @Override
    public String toString() {
        return name;
    }
}
