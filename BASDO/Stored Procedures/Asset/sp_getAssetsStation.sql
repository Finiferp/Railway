DELIMITER //

DROP PROCEDURE IF EXISTS sp_getAssetsStation;

CREATE PROCEDURE sp_getAssetsStation(IN json_input JSON)
BEGIN
    DECLARE asset_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE station_data JSON;
    DECLARE station_id INT;
    DECLARE station_name VARCHAR(450);
    DECLARE station_cost INT;
    DECLARE station_operation_cost INT;
    DECLARE asset_id_fk INT;

    SET asset_id = JSON_UNQUOTE(JSON_EXTRACT(json_input, '$.assetId'));
   
    SELECT s.idStation_PK, s.name, s.cost, s.operationCost, s.idAsset_FK
    INTO station_id, station_name, station_cost, station_operation_cost, asset_id_fk
    FROM Station s
    WHERE s.idAsset_FK = asset_id;


    IF station_id IS NOT NULL THEN
        SET response_code = 200;
        SET response_message = 'Station retrieved successfully';
        SET station_data = JSON_OBJECT(
            'idStation_PK', station_id,
            'name', station_name,
            'cost', station_cost,
            'operationCost', station_operation_cost,
            'idAsset_FK', asset_id_fk
        );
    ELSE
        SET response_code = 404;
        SET response_message = 'Asset has no Station';
    END IF;

    -- Returning the JSON response
    SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', station_data) AS 'result';

END //

DELIMITER ;
