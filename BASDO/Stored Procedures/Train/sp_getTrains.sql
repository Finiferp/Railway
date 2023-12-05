DELIMITER //
DROP PROCEDURE IF EXISTS sp_getTrains;
CREATE PROCEDURE sp_getTrains()
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE trains_data JSON;

    -- Retrieve all train data
    SET trains_data = (
        SELECT CONCAT('[', IFNULL(
            GROUP_CONCAT(
                JSON_OBJECT(
                    'id', idTrain_PK,
                    'name', name,
                    'cost', cost,
                    'operationalCost', operationalCost,
                    'railwayId', idRailway_FK,
                ) ORDER BY idTrain_PK
            ), '[]'
        ), ']') AS trains
        FROM Train
    );

    -- Check if any trains exist
    IF trains_data IS NULL OR trains_data = '[]' THEN
        -- No trains found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No trains found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Trains retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', trains_data) AS 'result';

END //
DELIMITER ;