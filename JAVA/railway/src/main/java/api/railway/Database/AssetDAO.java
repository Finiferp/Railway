package api.railway.Database;

import org.json.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AssetDAO {
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    private String server = "192.168.131.123";
    private int port = 3306;
    private String DBusername = "daniel";
    private String DBpassword = "q1w2e3r4t5!";
    private String database = "RailwayProject";

    public JSONObject getAssets() {
        String sql = "CALL sp_getAssets";
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                String jsonData = resultSet.getString("result");
                return new JSONObject(jsonData);
            } else {
                return new JSONObject();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }

    public JSONObject getAssetById(JSONObject json) {
        String sql = "CALL sp_getAsset(?)";
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            callableStatement.setString(1, json.toString());
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                String jsonData = resultSet.getString("result");
                return new JSONObject(jsonData);
            } else {
                return new JSONObject();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }

    public JSONObject createAsset(JSONObject json) {
        String sql = "CALL sp_createAsset(?)";
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            callableStatement.setString(1, json.toString());
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                String jsonData = resultSet.getString("result");
                return new JSONObject(jsonData);
            } else {
                return new JSONObject();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }

    public JSONObject getWorldAssets(JSONObject json) {
        String sql = "CALL sp_getWorldAssets(?)";
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            callableStatement.setString(1, json.toString());
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                String jsonData = resultSet.getString("result");
                return new JSONObject(jsonData);
            } else {
                return new JSONObject();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }

    public JSONObject buyAsset(JSONObject json) {
        String sql = "CALL sp_buyAsset(?)";
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            callableStatement.setString(1, json.toString());
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                String jsonData = resultSet.getString("result");
                return new JSONObject(jsonData);
            } else {
                return new JSONObject();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }

    public JSONObject getUserAssets(JSONObject json) {
        String sql = "CALL sp_getUserAssets(?)";
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            callableStatement.setString(1, json.toString());
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                String jsonData = resultSet.getString("result");
                return new JSONObject(jsonData);
            } else {
                return new JSONObject();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }

    public JSONObject getAssetsStation(JSONObject json) {
        String sql = "CALL sp_getAssetsStation(?)";
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            callableStatement.setString(1, json.toString());
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                String jsonData = resultSet.getString("result");
                return new JSONObject(jsonData);
            } else {
                return new JSONObject();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }
}
