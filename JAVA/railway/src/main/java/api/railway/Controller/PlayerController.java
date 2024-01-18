package api.railway.Controller;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.util.Map;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.apache.commons.codec.binary.Hex;
import java.util.Date;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import java.security.SecureRandom;
import java.util.Base64;

import api.railway.JwtTokenUtil;
import api.railway.Database.AssetDAO;
import api.railway.Database.PlayerDAO;

@RestController
public class PlayerController {

    private PlayerDAO playerDAO = new PlayerDAO();

    @GetMapping("/players")
    public ResponseEntity<Object> getPlayers() {
        JSONObject result = playerDAO.getPlayers();

        int status_code = result.getInt("status_code");
        String message = result.getString("message");
        JSONArray data = result.getJSONArray("data");

        JSONObject responseJson = new JSONObject();
        responseJson.put("data", data);
        responseJson.put("message", message);

        return ResponseEntity.status(status_code).body(responseJson.toMap());
    }

    @GetMapping("/player/{id}")
    public ResponseEntity<Object> getPlayer(@PathVariable Long id) {
        JSONObject inputJSON = new JSONObject();
        inputJSON.put("userId", id);
        JSONObject result = playerDAO.getPlayerById(inputJSON);
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

    @PostMapping("/player/stockpile")
    public ResponseEntity<Object> getPlayerStockpiles(@RequestBody Map<String, Object> requestBody) {
        String userId = (String) requestBody.get("userId");

        JSONObject inputJSON = new JSONObject();
        inputJSON.put("userId", userId);

        JSONObject result = playerDAO.getPlayerStockpiles(inputJSON);
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

    @PostMapping("/player/needs")
    public ResponseEntity<Object> getPlayerNeeds(@RequestBody Map<String, Object> requestBody) {
        String userId = (String) requestBody.get("userId");

        JSONObject inputJSON = new JSONObject();
        inputJSON.put("userId", userId);

        JSONObject result = playerDAO.getPlayerNeeds(inputJSON);
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

    
    @PostMapping("/player/railways")
    public ResponseEntity<Object> getPlayerRailways(@RequestBody Map<String, Object> requestBody) {
        String userId = (String) requestBody.get("userId");

        JSONObject inputJSON = new JSONObject();
        inputJSON.put("userId", userId);

        JSONObject result = playerDAO.getPlayerRailways(inputJSON);
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

    @PostMapping("/player/trains")
    public ResponseEntity<Object> getPlayersTrains(@RequestBody Map<String, Object> requestBody) {
        String userId = (String) requestBody.get("userId");

        JSONObject inputJSON = new JSONObject();
        inputJSON.put("userId", userId);

        JSONObject result = playerDAO.getPlayersTrains(inputJSON);
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
    @PostMapping("/player/industries")
    public ResponseEntity<Object> getPlayerIndustries(@RequestBody Map<String, Object> requestBody) {
        String userId = (String) requestBody.get("userId");

        JSONObject inputJSON = new JSONObject();
        inputJSON.put("userId", userId);

        JSONObject result = playerDAO.getPlayerIndustries(inputJSON);
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

    @PostMapping("/register")
    public ResponseEntity<Object> register(@RequestBody Map<String, Object> requestBody) {
        String username = (String) requestBody.get("username");
        String input_password = (String) requestBody.get("input_password");
        String salt = generateRandomSalt();
        String password = hashPassword(input_password, salt);
        JSONObject inputJSON = new JSONObject();
        inputJSON.put("password", password);
        inputJSON.put("username", username);
        inputJSON.put("salt", salt);
        JSONObject result = playerDAO.register(inputJSON);
        int status_code = result.getInt("status_code");
        String message = result.getString("message");
        JSONObject user = result.optJSONObject("user");
        int new_world_created = result.optInt("new_world_created");
        int new_world_id = result.optInt("new_world_id");
        if (new_world_created == 1) {
            generateWorld(new_world_id);
        }
        JSONObject responseJson = new JSONObject();
        if (user != null) {
            responseJson.put("user", user);
        }
        responseJson.put("message", message);
        return ResponseEntity.status(status_code).body(responseJson.toMap());
    }

    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody Map<String, Object> requestBody) {
        String username = (String) requestBody.get("username");
        String input_password = (String) requestBody.get("input_password");
        String salt = playerDAO.getSalt(username);
        // String token = generateAuthToken(username);
        String token = "NoToken because of Java";
        String password = hashPassword(input_password, salt);
        System.out.println(password);
        JSONObject inputJSON = new JSONObject();
        inputJSON.put("password", password);
        inputJSON.put("username", username);
        inputJSON.put("token", token);
        JSONObject result = playerDAO.login(inputJSON);
        int status_code = result.getInt("status_code");
        String message = result.getString("message");
        JSONObject user = result.optJSONObject("user");
        JSONObject responseJson = new JSONObject();
        if (user != null) {
            responseJson.put("user", user);
        }
        responseJson.put("message", message);
        return ResponseEntity.status(status_code).body(responseJson.toMap());
    }

    private String generateRandomSalt() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] saltBytes = new byte[32];
        secureRandom.nextBytes(saltBytes);
        return bytesToHex(saltBytes);
    }

    private String hashPassword(String inputPassword, String salt) {
        String result = "";
        KeySpec spec = new PBEKeySpec(inputPassword.toCharArray(), hexToBytes(salt), 10000, 512);
        try {
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA512");
            byte[] hashedBytes = factory.generateSecret(spec).getEncoded();
            result = bytesToHex(hashedBytes);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            e.printStackTrace();
        }
        return result;
    }

    public String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public byte[] hexToBytes(String hexString) {
        if (hexString == null || hexString.length() == 0) {
            return null;
        }

        byte[] bytes = new byte[hexString.length() / 2];
        for (int i = 0; i < hexString.length(); i += 2) {
            bytes[i / 2] = (byte) Integer.parseInt(hexString.substring(i, i + 2), 16);
        }

        return bytes;
    }

    public String generateAuthToken(String username) {
        long EXPIRATION_TIME = 12 * 3600 * 1000;
        Date expirationDate = new Date(System.currentTimeMillis() + EXPIRATION_TIME);
        JwtTokenUtil jwtTokenUtil = new JwtTokenUtil();
        String token = jwtTokenUtil.generateToken(username);
        System.out.println(token);
        return "s";

    }

    private Key getSigningKey() {
        String SECRET_KEY = "RailwayImperiumSecret";
        byte[] keyBytes = SECRET_KEY.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    private JSONObject generateRandomPosition(JSONArray existingPositions, int gridSize, int minDistance) {
        int x, y;
        do {
            x = (int) (Math.random() * gridSize);
            y = (int) (Math.random() * gridSize);
        } while (hasMinDistance(existingPositions, x, y, minDistance));

        return new JSONObject().put("x", x).put("y", y);
    }

    private boolean hasMinDistance(JSONArray existingPositions, int newX, int newY, int minDistance) {
        for (Object positionObj : existingPositions) {
            JSONObject position = (JSONObject) positionObj;
            double distance = Math.hypot(newX - position.getInt("x"), newY - position.getInt("y"));
            if (distance < minDistance) {
                return true; // Too close, try again
            }
        }
        return false; // Minimum distance satisfied
    }

    private void generateWorld(int worldId) {
        AssetDAO assetDAO = new AssetDAO();
        int gridSize = 1000;
        int minDistance = 50;
        int numTowns = 15;
        int numRuralBusinesses = 30;

        JSONArray towns = new JSONArray();
        JSONArray ruralBusinesses = new JSONArray();

        // Generate towns
        for (int i = 0; i < numTowns; i++) {
            JSONObject position = generateRandomPosition(new JSONArray(towns.toString()), gridSize, minDistance);
            towns.put(position);
        }

        // Generate rural businesses
        for (int i = 0; i < numRuralBusinesses; i++) {
            JSONObject position = generateRandomPosition(new JSONArray(towns.toString()), gridSize, minDistance);
            ruralBusinesses.put(position);
        }

        for (int i = 0; i < towns.length(); i++) {
            JSONObject town = towns.getJSONObject(i);
            JSONObject jsonTown = new JSONObject()
                    .put("type", "TOWN")
                    .put("name", "Town " + i)
                    .put("position", town)
                    .put("worldId", worldId);
            assetDAO.createAsset(jsonTown);
        }

        for (int i = 1; i < ruralBusinesses.length() + 1; i++) {
            JSONObject ruralBusiness = ruralBusinesses.getJSONObject(i);
            String business = "";
            if (i < 5) {
                business = "RANCH";
            } else if (i < 10) {
                business = "FIELD";
            } else if (i < 15) {
                business = "FARM";
            } else if (i < 20) {
                business = "LUMBERYARD";
            } else if (i < 25) {
                business = "PLANTATION";
            } else {
                business = "MINE";
            }
            JSONObject jsonRuralBusiness = new JSONObject()
                    .put("type", "RURALBUSINESS")
                    .put("name", "Rural Business" + i)
                    .put("position", ruralBusiness)
                    .put("worldId", worldId)
                    .put("business", business);
            assetDAO.createAsset(jsonRuralBusiness);
        }
    }

}
