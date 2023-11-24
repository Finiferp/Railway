DELIMITER //
DROP PROCEDURE IF EXISTS sp_getIndustries;
CREATE PROCEDURE sp_getIndustries()
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE industries_data JSON;

    -- Retrieve all industry data
    SET industries_data = (
        SELECT CONCAT('[', IFNULL(
            GROUP_CONCAT(
                JSON_OBJECT(
                    'id', idIndustry_PK,
                    'name', name,
                    'warehouseCapacity', warehouseCapacity,
                    'assetId', idAsset_FK
                ) ORDER BY idIndustry_PK
            ), '[]'
        ), ']') AS industries
        FROM Industry
    );

    -- Check if any industries exist
    IF industries_data IS NULL OR industries_data = '[]' THEN
        -- No industries found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No industries found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Industries retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', industries_data) AS 'result';

END //
DELIMITER ;