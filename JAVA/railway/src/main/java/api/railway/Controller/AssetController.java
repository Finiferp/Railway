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
import api.railway.Database.AssetDAO;

@RestController
public class AssetController {

  private AssetDAO assetDAO = new AssetDAO();

  @GetMapping("/assets")
  public ResponseEntity<Object> getAssets() {
    JSONObject result = assetDAO.getAssets();

    int status_code = result.getInt("status_code");
    String message = result.getString("message");
    JSONArray data = result.getJSONArray("data");

    JSONObject responseJson = new JSONObject();
    responseJson.put("data", data);
    responseJson.put("message", message);

    return ResponseEntity.status(status_code).body(responseJson.toMap());
  }

  @GetMapping("/asset/{id}")
  public ResponseEntity<Object> getAsset(@PathVariable Long id) {
    JSONObject inputJSON = new JSONObject();
    inputJSON.put("id", id);
    JSONObject result = assetDAO.getAssetById(inputJSON);
    int status_code = result.getInt("status_code");
    String message = result.getString("message");
    JSONObject data = result.optJSONObject("data");

    JSONObject responseJson = new JSONObject();
    if (data != null)
      responseJson.put("data", data);
    responseJson.put("message", message);
    return ResponseEntity.status(status_code).body(responseJson.toMap());
  }

  @GetMapping("/asset/player/{id}")
  public ResponseEntity<Object> getPlayerAssets(@PathVariable Long id) {
    JSONObject inputJSON = new JSONObject();
    inputJSON.put("id", id);
    JSONObject result = assetDAO.getUserAssets(inputJSON);
    int status_code = result.getInt("status_code");
    String message = result.getString("message");
    JSONObject data = result.optJSONObject("data");

    JSONObject responseJson = new JSONObject();
    if (data != null)
      responseJson.put("data", data);
    responseJson.put("message", message);
    return ResponseEntity.status(status_code).body(responseJson.toMap());
  }

  @PostMapping("/asset/buy")
  public ResponseEntity<Object> buyAsset(@RequestBody Map<String, Object> requestBody) {
    String userId = (String) requestBody.get("userId");
    int assetId = (int) requestBody.get("assetId");
    JSONObject inputJSON = new JSONObject();
    inputJSON.put("userId", userId);
    inputJSON.put("assetId", assetId);
    JSONObject result = assetDAO.buyAsset(inputJSON);
    int status_code = result.getInt("status_code");
    String message = result.getString("message");
    JSONObject data = result.optJSONObject("asset");

    JSONObject responseJson = new JSONObject();
    if (data != null) {
      responseJson.put("data", data);
    }
    responseJson.put("message", message);
    return ResponseEntity.status(status_code).body(responseJson.toMap());
  }

  @PostMapping("/asset/station")
  public ResponseEntity<Object> getAssetsStation(@RequestBody Map<String, Object> requestBody) {
    int assetId = (int) requestBody.get("assetId");
    JSONObject inputJSON = new JSONObject();
    inputJSON.put("assetId", assetId);
    JSONObject result = assetDAO.getAssetsStation(inputJSON);
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

  @GetMapping("/asset/world/{id}")
  public ResponseEntity<Object> getWorldAssets(@PathVariable Long id) {
    JSONObject inputJSON = new JSONObject();
    inputJSON.put("worldId", id);
    JSONObject result = assetDAO.getUserAssets(inputJSON);
    int status_code = result.getInt("status_code");
    String message = result.getString("message");
    JSONObject data = result.optJSONObject("data");

    JSONObject responseJson = new JSONObject();
    if (data != null)
      responseJson.put("data", data);
    responseJson.put("message", message);
    return ResponseEntity.status(status_code).body(responseJson.toMap());
  }

}
