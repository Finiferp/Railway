DELIMITER //

DROP PROCEDURE IF EXISTS sp_getPlayersTrains;

CREATE PROCEDURE sp_getPlayersTrains(IN inputJSON JSON)
BEGIN
    DECLARE input_user_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);
    DECLARE trains_data JSON;

    SET input_user_id = JSON_UNQUOTE(JSON_EXTRACT(inputJSON, '$.userId'));

    IF NOT EXISTS (SELECT 1 FROM Asset WHERE idOwner_FK = input_user_id AND type = 'TOWN') THEN
        SET response_code = 404;
        SET response_message = 'User not found or user does not own a town';
        SET trains_data = NULL;
    ELSE
        SET trains_data = (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', t.idTrain_PK,
                    'name', t.name,
                    'cost', t.cost,
                    'operationalCost', t.operationalCost,
                    'traveledDistance', t.traveledDistance,
                    'idRailway_FK', t.idRailway_FK,
                    'idAsset_Starts_FK', a_starts.name,
                    'idAsset_Destines_FK', a_destines.name,
                    'willReturnWithGoods', t.willReturnWithGoods,
                    'isReturning', t.isReturning,
                    'goodsTransported', (
                        SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                                'idname', g.name,
                                'amount', (
                                    SELECT COUNT(*)
                                    FROM Wagon w
                                    WHERE w.idTrain_FK = t.idTrain_PK
                                        AND w.idGood_Transport_FK = g.idGood_PK
                                )
                            )
                        )
                        FROM Good g
                        WHERE g.idGood_PK IN (SELECT DISTINCT idGood_Transport_FK FROM Wagon WHERE idTrain_FK = t.idTrain_PK)
                    )
                )
            ) AS trains
            FROM Train t
            JOIN Asset a_starts ON t.idAsset_Starts_FK = a_starts.idAsset_PK
            JOIN Asset a_destines ON t.idAsset_Destines_FK = a_destines.idAsset_PK
            WHERE a_starts.idOwner_FK = input_user_id
        );

        SET response_code = 200;
        SET response_message = 'Trains retrieved successfully';
    END IF;

    IF response_code = 200 THEN
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message, 'data', trains_data) AS 'result';
    ELSE
        SELECT JSON_OBJECT('status_code', response_code, 'message', response_message) AS 'result';
    END IF;

END //

DELIMITER ;
