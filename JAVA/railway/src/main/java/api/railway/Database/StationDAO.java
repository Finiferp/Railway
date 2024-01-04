package api.railway.Database;

import org.json.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StationDAO {
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

    public JSONObject getStations() {
        String sql = "CALL sp_getStations";
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

    public JSONObject getStationById(JSONObject json) {
        String sql = "CALL sp_getStation(?)";
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

    public JSONObject createStation(JSONObject json) {
      String sql = "CALL sp_createStation(?)";
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
     public JSONObject getStationByName(JSONObject json) {
      String sql = "CALL sp_getStationByName(?)";
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

