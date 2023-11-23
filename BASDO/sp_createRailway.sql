DELIMITER //

CREATE PROCEDURE sp_createRailway(IN jsonInput JSON)
BEGIN
    DECLARE station1Id INT;
    DECLARE station2Id INT;
    DECLARE railwayId INT;
    DECLARE errorOccurred BOOLEAN DEFAULT FALSE;
    
    -- Extract values from JSON input
    SET station1Id = JSON_UNQUOTE(JSON_EXTRACT(jsonInput, '$.station1Id'));
    SET station2Id = JSON_UNQUOTE(JSON_EXTRACT(jsonInput, '$.station2Id'));

    -- Check if required values are present
    IF station1Id IS NULL OR station2Id IS NULL THEN
        SELECT JSON_OBJECT('success', 'false', 'message', 'Invalid input: station1Id and station2Id are required') AS response;
        SET errorOccurred = TRUE;
    END IF;

    -- If no errors so far, proceed with creating the railway
    IF NOT errorOccurred THEN
        -- Create a new railway
        INSERT INTO Railway (cost) VALUES (/* add way to calculate cost based on locatoins */);

        -- Check if the insertion was successful
        IF ROW_COUNT() > 0 THEN
            -- Get the last inserted ID
            SET railwayId = LAST_INSERT_ID();

            -- Connect the railway to the stations
            INSERT INTO Connects (idStation_Connects_FK, idRailway_Connects_FK) VALUES (station1Id, railwayId);
            INSERT INTO Connects (idStation_Connects_FK, idRailway_Connects_FK) VALUES (station2Id, railwayId);

            -- Return a success JSON response
            SELECT JSON_OBJECT('success', 'true', 'message', 'Railway created successfully', 'railwayId', railwayId) AS response;
        ELSE
            -- Return an error JSON response if the insertion failed
            SELECT JSON_OBJECT('success', 'false', 'message', 'Railway creation failed') AS response;
        END IF;
    END IF;
END //

DELIMITER ;
