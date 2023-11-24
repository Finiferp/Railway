DELIMITER //
DROP PROCEDURE IF EXISTS sp_getGoods;
CREATE PROCEDURE sp_getGoods()
BEGIN
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE goods_data JSON;

    -- Retrieve all good data
    SET goods_data = (
        SELECT CONCAT('[', IFNULL(
            GROUP_CONCAT(
                JSON_OBJECT(
                    'id', idGood_PK,
                    'name', name,
                    'industryId', idIndustry_FK
                ) ORDER BY idGood_PK
            ), '[]'
        ), ']') AS goods
        FROM Good
    );

    -- Check if any goods exist
    IF goods_data IS NULL OR goods_data = '[]' THEN
        -- No goods found, set response code to 404 (Not Found)
        SET response_code = 404;
        SET response_message = 'No goods found';
    ELSE
        -- Set response code to 200 (OK)
        SET response_code = 200;
        SET response_message = 'Goods retrieved successfully';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', goods_data) AS 'result';

END //
DELIMITER ;