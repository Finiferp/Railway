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
import api.railway.Database.IndustryDAO;

@RestController
public class IndustryController {
      private IndustryDAO industryDAO = new IndustryDAO();

      @GetMapping("/industries")
      public ResponseEntity<Object> getIndustries() {
            JSONObject result = industryDAO.getIndustries();

            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONArray data = result.getJSONArray("data");

            JSONObject responseJson = new JSONObject();
            responseJson.put("data", data);
            responseJson.put("message", message);

            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @GetMapping("/industry/{id}")
      public ResponseEntity<Object> getIndustry(@PathVariable Long id) {
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("id", id);
            JSONObject result = industryDAO.getIndustryById(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject data = result.optJSONObject("data");

            JSONObject responseJson = new JSONObject();
            if (data != null)
                  responseJson.put("data", data);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }

      @PostMapping("industry/create")
      public ResponseEntity<Object> createIndustry(@RequestBody Map<String, Object> requestBody) {
            String name = (String) requestBody.get("name");
            int idAsset = (int) requestBody.get("idAsset");
            String type = (String) requestBody.get("type");
            JSONObject inputJSON = new JSONObject();
            inputJSON.put("name", name);
            inputJSON.put("idAsset", idAsset);
            inputJSON.put("type", type);
            JSONObject result = industryDAO.createIndustry(inputJSON);
            int status_code = result.getInt("status_code");
            String message = result.getString("message");
            JSONObject industry = result.optJSONObject("industry");
            JSONObject responseJson = new JSONObject();
            if (industry != null) responseJson.put("industry", industry);
            responseJson.put("message", message);
            return ResponseEntity.status(status_code).body(responseJson.toMap());
      }
}
