package api.railway.Controller;

import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import api.railway.Database.StationDAO;

@RestController
public class StationController {
      private StationDAO stationDAO = new StationDAO();

      @GetMapping("/stations")
      public ResponseEntity<Object> getStations() {
            JSONObject result = stationDAO.getStations();

            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONArray data = result.getJSONArray("data");

            JSONObject responseJson = new JSONObject();
            responseJson.put("data", data);
            responseJson.put("message", message);

            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @GetMapping("/station/{id}")
      public ResponseEntity<Object> getStation(@PathVariable Long id) {
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("id", id);
            JSONObject result = stationDAO.getStationById(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject data = result.optJSONObject("data");

            JSONObject responseJson = new JSONObject();
            if (data != null)
                  responseJson.put("data", data);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @PostMapping("/station/create")
      public ResponseEntity<Object> createStation(@RequestBody Map<String, Object> requestBody) {
            String name = (String) requestBody.get("name");
            int assetId = (int) requestBody.get("assetId");
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("name", name);
            inputJSON.put("assetId", assetId);
            JSONObject result = stationDAO.createStation(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject station = result.optJSONObject("station");
            JSONObject responseJson = new JSONObject();
            if (station != null)
                  responseJson.put("station", station);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @PostMapping("/station/name")
      public ResponseEntity<Object> spGetStationByName(@RequestBody Map<String, Object> requestBody) {
            String station_name = (String) requestBody.get("station_name");
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("station_name", station_name);
            JSONObject result = stationDAO.getStationByName(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject data = result.optJSONObject("data");

            JSONObject responseJson = new JSONObject();
            if (data != null) {
                  responseJson.put("data", data);
            }
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }
}
