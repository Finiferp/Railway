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
import api.railway.Database.RailwayDAO;

@RestController
public class RailwayController {
      private RailwayDAO railwayDAO = new RailwayDAO();

      @GetMapping("/railways")
      public ResponseEntity<Object> getRailways() {
            JSONObject result = railwayDAO.getRailways();

            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONArray data = result.getJSONArray("data");

            JSONObject responseJson = new JSONObject();
            responseJson.put("data", data);
            responseJson.put("message", message);

            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @GetMapping("/railway/{id}")
      public ResponseEntity<Object> getRailway(@PathVariable Long id) {
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("id", id);
            JSONObject result = railwayDAO.getRailwayById(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject data = result.optJSONObject("data");

            JSONObject responseJson = new JSONObject();
            if (data != null)
                  responseJson.put("data", data);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @PostMapping("railway/create")
      public ResponseEntity<Object> createRailway(@RequestBody Map<String, Object> requestBody) {
            int station1Id = (int) requestBody.get("station1Id");
            int station2Id = (int) requestBody.get("station2Id");
            int userId = (int) requestBody.get("userId");
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("station1Id", station1Id);
            inputJSON.put("station2Id", station2Id);
            inputJSON.put("userId", userId);
            JSONObject result = railwayDAO.createRailway(inputJSON);
            System.out.println(result);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject railway = result.optJSONObject("railway");
            JSONObject responseJson = new JSONObject();
            if (railway != null) responseJson.put("railway", railway);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }
}
