DELIMITER //
DROP PROCEDURE IF EXISTS sp_Register;
CREATE PROCEDURE sp_Register(IN json_data JSON)
BEGIN
    DECLARE input_username VARCHAR(80);
    DECLARE input_password VARCHAR(10000);
    DECLARE input_salt VARCHAR(450);
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE max_world_id INT;
	DECLARE new_world_created INT;
    -- Extracting data from JSON input
    SET input_username = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.username'));
    SET input_password = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.password'));
    SET input_salt = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.salt'));

    -- Checking if the username already exists
    IF EXISTS (SELECT 1 FROM Player WHERE username = input_username) THEN
        -- Username already exists, set response code to 400 (Bad Request)
        SET response_code = 400;
        SET response_message = 'Username already exists';
        SET new_world_created = 0;
    ELSE
		SET max_world_id = (SELECT MAX(idWorld_PK) FROM World);
        
        SET @player_count = (SELECT COUNT(*) FROM Player WHERE idWorld_FK = max_world_id);

       IF @player_count >= 20 THEN
            -- Create a new World if the current World has 20 players
            INSERT INTO World () VALUES (); -- Omitting the creationDate column
            SET new_world_created = 1;
        ELSE
            SET new_world_created = 0;
        END IF;

        -- Get the ID of the latest World (whether existing or newly created)
        SET @new_world_id = (SELECT MAX(idWorld_PK) FROM World);

        -- Insert the new user into the Player table with the new World ID
        INSERT INTO Player (username, password, salt, idWorld_FK) VALUES (input_username, input_password, input_salt, @new_world_id);

        -- Set response code to 201 (Created)
        SET response_code = 201;
        SET response_message = 'User registered successfully';
    END IF;

    -- Returning the JSON response with all user columns if successful
    IF response_code = 201 THEN
        SELECT 
            JSON_OBJECT(
                'status_code', response_code, 
                'message', response_message,
                'new_world_created', new_world_created,
                'new_world_id', @new_world_id,
                'user', JSON_OBJECT(
                    'id', idPlayer_PK, 
                    'username', username, 
                    'password', password, 
                    'salt', salt, 
                    'world_id', idWorld_FK
                )
            ) AS 'result'
        FROM Player WHERE username = input_username;
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //

DELIMITER ;