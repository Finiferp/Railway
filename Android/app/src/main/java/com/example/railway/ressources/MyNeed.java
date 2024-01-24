package com.example.railway.ressources;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class MyNeed {
    private String assetName, assetId, good;

    public MyNeed(String assetName, String assetId, String good) {
        this.assetName = assetName;
        this.assetId = assetId;
        this.good = good;
    }

    public String getAssetName() {
        return assetName;
    }

    public String getAssetId() {
        return assetId;
    }

    public String getGood() {;
        return good;
    }


}
