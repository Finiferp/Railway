DELIMITER //

DROP PROCEDURE IF EXISTS sp_getPlayerRailways;

CREATE PROCEDURE sp_getPlayerRailways(IN inputJSON JSON)
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE data JSON;
    DECLARE input_user_id INT;

    -- Extracting userId from input JSON
    SET input_user_id = JSON_UNQUOTE(JSON_EXTRACT(inputJSON, '$.userId'));

    -- Selecting stations and connected railways for the given user
    SET data = (
        SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'station_id', s.idStation_PK,
                    'station_name', s.name,
                    'railways', (
                        SELECT JSON_ARRAYAGG(
                                JSON_OBJECT(
                                    'railway_id', r.idRailway_PK,
                                    'distance', r.distance,
                                    'connected_stations', (
                                        SELECT JSON_ARRAYAGG(
                                                JSON_OBJECT(
                                                    'connected_station_id', cs.idStation_PK,
                                                    'connected_station_name', cs.name,
                                                    'assetId', cs.idAsset_FK
                                                )
                                            )
                                        FROM Connects c2
                                        JOIN Station cs ON c2.idStation_Connects_FK = cs.idStation_PK
                                        WHERE c2.idRailway_Connects_FK = r.idRailway_PK
                                    )
                                )
                            )
                        FROM Connects c1
                        JOIN Railway r ON c1.idRailway_Connects_FK = r.idRailway_PK
                        WHERE c1.idStation_Connects_FK = s.idStation_PK
                    )
                )
            )
        FROM Station s
        JOIN Asset a ON s.idAsset_FK = a.idAsset_PK
        WHERE a.idOwner_FK = input_user_id
    );

    -- Handling response based on the data
    IF data IS NULL OR data = '[]' THEN
        -- No stations found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No stations found for the player';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Stations and railways retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', data) AS 'result';

END //

DELIMITER ;
