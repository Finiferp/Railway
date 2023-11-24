DELIMITER //
DROP PROCEDURE IF EXISTS sp_createRailway;
CREATE PROCEDURE sp_createRailway(IN json_data JSON)
BEGIN
    DECLARE input_station1_id INT;
    DECLARE input_station2_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE new_railway_id INT;

    -- Extracting data from JSON input
    SET input_station1_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.station1Id'));
    SET input_station2_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.station2Id'));

    -- Check if both stations exist
    IF NOT EXISTS (SELECT 1 FROM Station WHERE idStation_PK = input_station1_id) THEN
        -- Station 1 does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'Station 1 not found';
    ELSEIF NOT EXISTS (SELECT 1 FROM Station WHERE idStation_PK = input_station2_id) THEN
        -- Station 2 does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'Station 2 not found';
    ELSE
        -- Insert the new railway into the Railway table
        INSERT INTO Railway (cost)
        VALUES (0); -- Assuming default value for cost

        -- Get the ID of the newly inserted railway
        SET new_railway_id = LAST_INSERT_ID();

        -- Insert the connections into the Connects table
        INSERT INTO Connects (idStation_Connects_FK, idRailway_Connects_FK)
        VALUES (input_station1_id, new_railway_id), (input_station2_id, new_railway_id);

        -- Set response code to 200 (OK) and return the created railway
        SET response_code = 200;
        SET response_message = 'Railway created successfully';
    END IF;

    -- Returning the JSON response
    IF response_code = 200 THEN
        SELECT JSON_OBJECT(
            'status_code', response_code,
            'message', response_message,
            'railway', JSON_OBJECT(
                'id', new_railway_id,
                'station1Id', input_station1_id,
                'station2Id', input_station2_id
            )
        ) AS 'result';
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //

DELIMITER ;
