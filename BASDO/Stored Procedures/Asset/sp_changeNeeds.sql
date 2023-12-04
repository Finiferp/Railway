DELIMITER //
DROP PROCEDURE IF EXISTS sp_changeNeeds;
CREATE PROCEDURE sp_changeNeeds(IN assetId INT, assetLevel INT, levelup INT)
BEGIN
	IF levelup = 1 THEN
		UPDATE Needs SET consumption = consumption + 1 WHERE idAsset_Needs_PKFK = assetId;
		IF assetLevel = 1 THEN
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,3,0.5);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,2,0.8);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,4,0.3);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,12,0.5);
		ELSEIF assetLevel = 2 THEN
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,5,0.3);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,13,0.8);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,22,0.5);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,6,0.4);
		ELSEIF assetLevel = 3 THEN
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,23,0.3);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,7,0.3);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,15,0.5);
		ELSEIF assetLevel = 4 THEN
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,16,0.3);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,17,0.8);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption) VALUES (assetID,18,0.4);
		ELSE
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption)VALUES(assetID,20,0.3);
			INSERT INTO Needs (idAsset_Needs_PKFK,idGood_Needs_PKFK,consumption)VALUES(assetID,19,0.2);
		END IF;
	ELSE
		IF assetLevel = 1 THEN
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 5;
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 13;
            DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 22;
            DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 6;
		ELSEIF assetLevel = 2 THEN
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 23;
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 7;
            DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 15;
		ELSEIF assetLevel = 3 THEN
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 16;
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 17;
            DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 18;
		ELSE 
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 20;
			DELETE FROM Needs WHERE idAsset_Needs_PKFK = assetID AND idGood_Needs_PKFK = 19;
		END IF;
		UPDATE Needs SET consumption = consumption - 1 WHERE idAsset_Needs_PKFK = assetId;
    END IF;
END //
DELIMITER ;