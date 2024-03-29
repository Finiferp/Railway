package api.railway.Controller;

import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import api.railway.Database.TrainDAO;

@RestController
public class TrainController {
      private TrainDAO trainDAO = new TrainDAO();

      @GetMapping("/trains")
      public ResponseEntity<Object> getTrains() {
            JSONObject result = trainDAO.getTrains();

            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONArray data = result.getJSONArray("data");

            JSONObject responseJson = new JSONObject();
            responseJson.put("data", data);
            responseJson.put("message", message);

            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @GetMapping("/train/{id}")
      public ResponseEntity<Object> getTrain(@PathVariable Long id) {
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("id", id);
            JSONObject result = trainDAO.getTrainById(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject data = result.optJSONObject("data");

            JSONObject responseJson = new JSONObject();
            if (data != null)
                  responseJson.put("data", data);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @PostMapping("train/create")
      public ResponseEntity<Object> createTrain(@RequestBody Map<String, Object> requestBody) {
            String name = (String) requestBody.get("name");
            int idRailway = (int) requestBody.get("idRailway");
            int idAsset_Starts = (int) requestBody.get("idAsset_Starts");
            int idAsset_Destines = (int) requestBody.get("idAsset_Destines");
            int willReturnWithGoods = (int) requestBody.get("willReturnWithGoods");
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("name", name);
            inputJSON.put("idRailway", idRailway);
            inputJSON.put("idAsset_Starts", idAsset_Starts);
            inputJSON.put("idAsset_Destines", idAsset_Destines);
            inputJSON.put("willReturnWithGoods", willReturnWithGoods);
            JSONObject result = trainDAO.createTrain(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject train = result.optJSONObject("train");
            JSONObject responseJson = new JSONObject();
            if (train != null) responseJson.put("train", train);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @DeleteMapping("/train/delete")
      public ResponseEntity<Object> deleteTrain(@RequestBody Map<String, Object> requestBody) {
            int trainId = (int) requestBody.get("trainId");
            int userId = (int) requestBody.get("userId");
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("trainId", trainId);
            inputJSON.put("userId",userId);
            JSONObject result = trainDAO.deleteTrain(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
        
            JSONObject responseJson = new JSONObject();
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @PostMapping("train/demand")
      public ResponseEntity<Object> demandTrain(@RequestBody Map<String, Object> requestBody) {
            int railwayId = (int) requestBody.get("railwayId");
            int assetFromId = (int) requestBody.get("assetFromId");
            int assetToId = (int) requestBody.get("assetToId");
            int goodId = (int) requestBody.get("goodId");
            int amount = (int) requestBody.get("amount");
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("railwayId", railwayId);
            inputJSON.put("assetFromId", assetFromId);
            inputJSON.put("assetToId", assetToId);
            inputJSON.put("goodId", goodId);
            inputJSON.put("amount", amount);
            JSONObject result = trainDAO.demandTrain(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject responseJson = new JSONObject();
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }
}
