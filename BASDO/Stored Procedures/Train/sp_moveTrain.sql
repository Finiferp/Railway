DELIMITER //
DROP PROCEDURE IF EXISTS sp_moveTrain;
CREATE PROCEDURE sp_moveTrain()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE trainID INT;
    DECLARE ownerID INT;
    DECLARE receiverID INT;
    DECLARE railwayDistance INT;
    DECLARE trainDistance INT;
    DECLARE days_needed INT;
    DECLARE isReturning TINYINT;
    DECLARE train_cursor CURSOR FOR SELECT idTrain_PK FROM Train;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN train_cursor;
    train_loop: LOOP
        FETCH train_cursor INTO trainID;

        IF done = 1 THEN
            LEAVE train_loop;
        END IF;

        SELECT t.traveledDistance, t.isReturning, r.distance
        INTO trainDistance,isReturning, railwayDistance
        FROM Train t
        JOIN Railway r ON t.idRailway_FK = r.idRailway_PK
        WHERE t.idTrain_PK = trainID;

        IF isReturning = 0 THEN
        UPDATE Train
        SET traveledDistance = traveledDistance + 50
        WHERE idTrain_PK = trainID;
        
        IF (trainDistance+50)>=railwayDistance THEN
            SELECT idOwner_FK INTO ownerID
            FROM Train JOIN Asset 
            WHERE idAsset_Starts_FK = idAsset_PK AND trainID = idTrain_PK;

            SELECT idOwner_FK INTO receiverID
            FROM Train JOIN Asset 
            WHERE idAsset_Destines_FK = idAsset_PK AND trainID = idTrain_PK;

            SET days_needed = (trainDistance+50)/50;

            CALL sp_trainArrived(trainID, ownerID, days_needed,receiverID);
        END IF;

    ELSE
        UPDATE Train
        SET traveledDistance = traveledDistance - 50
        WHERE idTrain_PK = trainID;
        
        IF (trainDistance-50)<=0 THEN
            SELECT idOwner_FK INTO ownerID
            FROM Train JOIN Asset 
            WHERE idAsset_Starts_FK = idAsset_PK AND trainID = idTrain_PK;

            SELECT idOwner_FK INTO receiverID
            FROM Train JOIN Asset 
            WHERE idAsset_Destines_FK = idAsset_PK AND trainID = idTrain_PK;

            SET days_needed = (trainDistance+50)/50;

            CALL sp_trainArrived(trainID, receiverID, days_needed, ownerID);
        END IF;

    END IF;
    END LOOP;

    CLOSE train_cursor;
END //
DELIMITER ;