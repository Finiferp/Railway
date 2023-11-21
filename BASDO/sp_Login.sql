DELIMITER //
DROP PROCEDURE IF EXISTS sp_Login;
CREATE PROCEDURE sp_Login(IN json_data JSON)
BEGIN
    DECLARE input_username VARCHAR(80);
    DECLARE input_password VARCHAR(80);
    DECLARE stored_password VARCHAR(80);
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);

    -- Extracting data from JSON input
    SET input_username = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.username'));
    SET input_password = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.password'));

    -- Checking if the username exists
    IF NOT EXISTS (SELECT 1 FROM Player WHERE username = input_username) THEN
        -- Username does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'Username not found';
    ELSE
        -- Retrieve the stored password for the given username
        SET stored_password = (SELECT password FROM Player WHERE username = input_username);

        -- Check if the provided password matches the stored password
        IF input_password = stored_password THEN
            -- Passwords match, set response code to 200 (OK)
            SET response_code = 200;
            SET response_message = 'Login successful';
        ELSE
            -- Passwords do not match, set response code to 401 (Unauthorized)
            SET response_code = 401;
            SET response_message = 'Incorrect password';
        END IF;
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';

END //

DELIMITER ;
