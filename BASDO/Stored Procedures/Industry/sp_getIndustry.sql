DELIMITER //
DROP PROCEDURE IF EXISTS sp_getIndustry;
CREATE PROCEDURE sp_getIndustry(IN json_data JSON)
BEGIN
    DECLARE input_industry_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE industry_data JSON;

    -- Extracting data from JSON input
    SET input_industry_id = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.id'));

    -- Checking if the industry ID exists
    IF NOT EXISTS (SELECT 1 FROM Industry WHERE idIndustry_PK = input_industry_id) THEN
        -- Industry ID does not exist, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'Industry not found';
        SET industry_data = NULL; -- Set industry_data to NULL when industry is not found
    ELSE
        -- Retrieve industry data for the given industry ID
        SET industry_data = (
            SELECT JSON_OBJECT(
                'id', idIndustry_PK,
                'name', name,
                'warehouseCapacity', warehouseCapacity,
                'assetId', idAsset_FK
            )
            FROM Industry
            WHERE idIndustry_PK = input_industry_id
        );

        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Industry retrieved successfully';
    END IF;

    -- Returning the JSON response
    IF response_code = 200 THEN
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', industry_data) AS 'result';
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //

DELIMITER ;