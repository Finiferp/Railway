package railway.api.Controller;

import railway.api.Database.AssetDAO;
import railway.api.Database.PlayerDAO;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.util.Map;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.codec.Hex;
import org.springframework.security.crypto.keygen.BytesKeyGenerator;
import org.springframework.security.crypto.keygen.KeyGenerators;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

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
        String password = hashPassword(input_password, salt);
        JSONObject inputJSON = new JSONObject();
        System.out.println(inputJSON);
        inputJSON.put("password", password);
        inputJSON.put("username", username);
        inputJSON.put("salt", salt);
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
        BytesKeyGenerator keyGenerator = KeyGenerators.secureRandom(32);
        byte[] saltBytes = keyGenerator.generateKey();
        return new String(Hex.encode(saltBytes));
    }

    private String hashPassword(String inputPassword, String salt) {
        String result = "";
        KeySpec spec = new PBEKeySpec(inputPassword.toCharArray(), Hex.decode(salt), 10000, 512);
        try {
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA512");
            byte[] hashedBytes = factory.generateSecret(spec).getEncoded();
            result = new String(Hex.encode(hashedBytes));
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            e.printStackTrace();
        }
        return result;
    }

    public static String generateAuthToken(String username) {
        Key SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);
        long EXPIRATION_TIME = 12 * 3600 * 1000;
        Date expirationDate = new Date(System.currentTimeMillis() + EXPIRATION_TIME);

        String token = Jwts.builder()
                .setSubject(username)
                .setExpiration(expirationDate)
                .signWith(SECRET_KEY)
                .compact();

        return token;
    }

    private static JSONObject generateRandomPosition(JSONArray existingPositions, int gridSize, int minDistance) {
        int x, y;
        do {
            x = (int) (Math.random() * gridSize);
            y = (int) (Math.random() * gridSize);
        } while (hasMinDistance(existingPositions, x, y, minDistance));

        return new JSONObject().put("x", x).put("y", y);
    }

    // Function to check if a position has a minimum distance from existing
    // positions
    private static boolean hasMinDistance(JSONArray existingPositions, int newX, int newY, int minDistance) {
        for (Object positionObj : existingPositions) {
            JSONObject position = (JSONObject) positionObj;
            double distance = Math.hypot(newX - position.getInt("x"), newY - position.getInt("y"));
            if (distance < minDistance) {
                return true; // Too close, try again
            }
        }
        return false; // Minimum distance satisfied
    }

    // Function to generate a world with towns and rural businesses
    private static void generateWorld(int worldId) {
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

        for (int i = 0; i < ruralBusinesses.length(); i++) {
            JSONObject ruralBusiness = ruralBusinesses.getJSONObject(i);
            JSONObject jsonRuralBusiness = new JSONObject()
                    .put("type", "RURALBUSINESS")
                    .put("name", "Rural Business" + i)
                    .put("position", ruralBusiness)
                    .put("worldId", worldId);
            assetDAO.createAsset(jsonRuralBusiness);
        }
    }

}
