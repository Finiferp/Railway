DELIMITER //
DROP PROCEDURE IF EXISTS sp_trainArrived;
CREATE PROCEDURE sp_trainArrived(IN trainId INT, ownerID INT, days_needed INT,receiverID INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE wagonGoodID INT;
    DECLARE fundsToAdd INT;
    DECLARE totalStockpileQuantity INT;
    DECLARE willReturnWithGoods TINYINT DEFAULT 0;
    DECLARE traveledDistance INT;
    DECLARE wagon_cursor CURSOR FOR
        SELECT idGood_Transport_FK
        FROM Wagon
        WHERE idTrain_FK = trainId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT willReturnWithGoods, traveledDistance INTO willReturnWithGoods, traveledDistance
    FROM Train
    WHERE idTrain_PK = trainId;

    SELECT SUM(quantity) INTO totalStockpileQuantity
    FROM Stockpiles
    WHERE idAsset_Stockpiles_PKFK = receiverID;


    OPEN wagon_cursor;
    wagon_loop: LOOP
        FETCH wagon_cursor INTO wagonGoodID;
        IF done = 1 THEN
            LEAVE wagon_loop;
        END IF;

        IF wagonGoodID = 24 THEN
            SET fundsToAdd := 100 * days_needed;
        ELSEIF wagonGoodID = 25 THEN
            SET fundsToAdd := 10000 - (500 * days_needed);
        ELSEIF wagonGoodID IN (3, 2, 4, 12) THEN
            SET fundsToAdd := 1000;
        ELSEIF wagonGoodID IN (5, 13, 22, 6) THEN
            SET fundsToAdd := 1000 * 2;
        ELSEIF wagonGoodID IN (23, 7, 15) THEN
            SET fundsToAdd := 1000 * 3;
        ELSEIF wagonGoodID IN (16, 17, 18) THEN
            SET fundsToAdd := 1000 * 4;
        ELSEIF wagonGoodID IN (20, 19) THEN
            SET fundsToAdd := 1000 * 5;
        END IF;
        
        CALL sp_addFunds(fundsToAdd, ownerID);

         IF totalStockpileQuantity + 1 <= (SELECT stockpileMax FROM Asset WHERE idAsset_PK = receiverID) THEN
            UPDATE Stockpiles
            SET quantity = quantity + 1
            WHERE idAsset_Stockpiles_PKFK = receiverID AND idGoodt_Stockpiles_PKFK = wagonGoodID;
        END IF;
        DELETE FROM Wagon WHERE idWagon_PK = wagonGoodID; 
    END LOOP;
    CLOSE wagon_cursor;

    IF willReturnWithGoods = 1 AND traveledDistance <= 0 THEN
        CALL sp_fillTrain(ownerID, receiverID ,trainId);
    END IF;

    UPDATE Train
    SET isReturning = 1
    WHERE idTrain_PK = trainId;

END //
DELIMITER ;