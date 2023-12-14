package api.railway.Database;

import org.json.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RailwayDAO {
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

    public JSONObject getRailways() {
        String sql = "CALL sp_getRailways";
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

    public JSONObject getRailwayById(JSONObject json) {
        String sql = "CALL sp_getRailway(?)";
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

    public JSONObject createRailway(JSONObject json) {
        String sql = "CALL sp_createRailway(?)";
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
