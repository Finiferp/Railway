package railway.api.Database;

import org.json.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PlayerDAO {

    private String server = "192.168.131.123";
    private int port = 3306;
    private String DBusername = "daniel";
    private String DBpassword = "q1w2e3r4t5!";
    private String database = "RailwayProject";

    public JSONObject getPlayers() {
        String sql = "CALL sp_getPlayers";
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

    public JSONObject getPlayerById(JSONObject json) {
        String sql = "CALL sp_getPlayer(?)";
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

    public JSONObject register(JSONObject json) {
        String sql = "CALL sp_register(?)";
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

    public JSONObject login(JSONObject json) {
        String sql = "CALL sp_login(?)";
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

    public String getSalt(String username){
        String sql = "CALL sp_getSalt(?)";
        String result="";
         try (Connection connect = DriverManager.getConnection("jdbc:mysql://" + server + ":" + port + "/" + database
                + "?user=" + DBusername + "&password=" + DBpassword);
                CallableStatement callableStatement = connect.prepareCall(sql)) {
            callableStatement.setString(1, username);
            ResultSet resultSet = callableStatement.executeQuery();

            if (resultSet.next()) {
                result = resultSet.getString("salt");
                return result;
            } else {
                return result;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return result;
        }
    }

}
