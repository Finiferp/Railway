package com.example.railway.ressources;

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

    public String getGoods() {
        return goods;
    }

    public String getOwner() {
        return owner;
    }
}
