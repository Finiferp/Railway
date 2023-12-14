package api.railway.Controller;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import api.railway.Database.WorldDAO;

@RestController
public class WorldController {
  private WorldDAO worldDAO = new WorldDAO();
    @GetMapping("/worlds")
    public ResponseEntity<Object> getWorlds() {
      JSONObject result = worldDAO.getWorlds();

      int status_code = result.getInt("status_code");
      String message = result.getString("message");
      JSONArray data = result.getJSONArray("data");

      JSONObject responseJson = new JSONObject();
      responseJson.put("data", data);
      responseJson.put("message", message);

      return ResponseEntity.status(status_code).body(responseJson.toMap());
  }

    @GetMapping("/world/{id}")
    public ResponseEntity<Object> getWorld(@PathVariable Long id){
      JSONObject inputJSON = new JSONObject();
      inputJSON.put("id", id);
      JSONObject result = worldDAO.getWorldById(inputJSON);
      System.out.println(result);
      int status_code = result.getInt("status_code");
      String message = result.getString("message");
      JSONObject data = result.optJSONObject("data");


      JSONObject responseJson = new JSONObject();
      if(data != null) responseJson.put("data", data);
      responseJson.put("message", message);
      return ResponseEntity.status(status_code).body(responseJson.toMap());
    }

}
