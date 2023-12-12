package railway.api.Controller;

import railway.api.Database.AssetDAO;

import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

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
    public ResponseEntity<Object> getAsset(@PathVariable Long id){
      JSONObject inputJSON = new JSONObject();
      inputJSON.put("id", id);
      JSONObject result = assetDAO.getAssetById(inputJSON);
      int status_code = result.getInt("status_code");
      String message = result.getString("message");
      JSONObject data = result.optJSONObject("data");


      JSONObject responseJson = new JSONObject();
      if(data!=null) responseJson.put("data", data);
      responseJson.put("message", message);
      return ResponseEntity.status(status_code).body(responseJson.toMap());
    }

    /*@PostMapping("asset/create")
    public ResponseEntity<Object> createAsset(@RequestBody Map<String, Object> requestBody){




      return ResponseEntity.status(status_code).body(responseJson.toMap());
    }*/
}