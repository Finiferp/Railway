DELIMITER //
DROP PROCEDURE IF EXISTS sp_Register;
CREATE PROCEDURE sp_Register(IN json_data JSON)
BEGIN
    DECLARE input_username VARCHAR(80);
    DECLARE input_password VARCHAR(80);
    DECLARE input_salt VARCHAR(450);
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);

    -- Extracting data from JSON input
    SET input_username = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.username'));
    SET input_password = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.password'));
    SET input_salt = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.salt'));

    -- Checking if the username already exists
    IF EXISTS (SELECT 1 FROM Player WHERE username = input_username) THEN
        -- Username already exists, set response code to 409 (Conflict)
        SET response_code = 409;
        SET response_message = 'Username already exists';
    ELSE
        -- Checking the number of players in the World
        SET @player_count = (SELECT COUNT(*) FROM Player);

        IF @player_count >= 20 THEN
            -- Create a new World if the current World has 20 players
                INSERT INTO World () VALUES (); -- Omitting the creationDate column
		END IF;

        -- Get the ID of the latest World (whether existing or newly created)
        SET @new_world_id = (SELECT MAX(idWorld_PK) FROM World);

        -- Insert the new user into the Player table with the new World ID
        INSERT INTO Player (username, password, salt, idWorld_FK) VALUES (input_username, input_password, input_salt, @new_world_id);
        
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'User registered successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';

END //

DELIMITER ;
