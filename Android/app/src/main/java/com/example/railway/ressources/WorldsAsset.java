package com.example.railway.ressources;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class WorldsAsset {
    private String name, type, position, population, level, goods, owner;
    private int id;

    public WorldsAsset(String name, String type, String position, String population, String level, String goods, String owner,int id) {
        this.name = name;
        this.type = type;
        this.position = position;
        this.population = population;
        this.level = level;
        this.goods = goods;
        this.owner = owner;
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }

    public String getType() {
        return type;
    }

    public String getPosition() {
        return position;
    }

    public String getPopulation() {
        return population;
    }

    public String getLevel() {
        return level;
    }

    public String getGoods()  {
        String res="";
        System.out.println(goods);
        if(!goods.equals("null")) {
            try {
                JSONArray jsonArray = new JSONArray(goods);
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject jsonObject = jsonArray.getJSONObject(i);
                    String name = jsonObject.getString("name");
                    res += name + "\r\n";
                }
            } catch (JSONException e) {
                throw new RuntimeException(e);
            }
        } else {
            res="No Goods produced.";
        }

        System.out.println(res);
        return res;
    }

    public String getOwner() {
        return owner;
    }
}
