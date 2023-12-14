DELIMITER //
DROP PROCEDURE IF EXISTS sp_createRailway;
CREATE PROCEDURE sp_createRailway(IN json_data JSON)
BEGIN
    DECLARE input_station1_id INT;
    DECLARE input_station2_id INT;
    DECLARE userId INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE new_railway_id INT;
    DECLARE railwayCountStation1 INT;
    DECLARE railwayCountStation2 INT;
    DECLARE distance INT;
    -- Extracting data from JSON input
    SET input_station1_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.station1Id'));
    SET input_station2_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.station2Id'));
    SET userId = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.userId'));

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
        SELECT COUNT(*) INTO railwayCountStation1 FROM Connects WHERE idStation_Connects_FK = input_station1_id;
		SELECT COUNT(*) INTO railwayCountStation2 FROM Connects WHERE idStation_Connects_FK = input_station2_id;

		IF railwayCountStation1 >= 10 OR railwayCountStation2 >= 10 THEN
            -- Maximum limit reached, set response code to 400 (Bad Request)
            SET response_code = 400;
            SET response_message = 'Maximum limit of railways per station reached for one or both stations';
        ELSE
			SELECT 
			ROUND(
				SQRT(
					POW(ST_X(position) - ST_X((SELECT position FROM Asset WHERE idAsset_PK = input_station2_id)), 2) +
					POW(ST_Y(position) - ST_Y((SELECT position FROM Asset WHERE idAsset_PK = input_station2_id)), 2)
				)
			) INTO distance
			FROM Asset
			WHERE idAsset_PK = input_station1_id;
			INSERT INTO Railway (distance) VALUES (distance);
            
			SET new_railway_id = LAST_INSERT_ID();

			INSERT INTO Connects (idStation_Connects_FK, idRailway_Connects_FK)
			VALUES (input_station1_id, new_railway_id), (input_station2_id, new_railway_id);

			SET response_code = 200;
			SET response_message = 'Railway created successfully';
            
            CALL sp_deleteFunds(distance*100, userId);
			END IF;
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
