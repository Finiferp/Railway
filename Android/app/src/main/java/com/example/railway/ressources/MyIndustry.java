package com.example.railway.ressources;

import android.widget.TableLayout;

public class MyIndustry {
    private String name;
    private TableLayout industries;
    private int assetId;

    public MyIndustry(String name, TableLayout industries, int assetId) {
        this.name = name;
        this.industries = industries;
        this.assetId = assetId;
    }

    public String getName() {
        return name;
    }

    public TableLayout getIndustries() {
        return industries;
    }

    public int getAssetId() {
        return assetId;
    }
}
