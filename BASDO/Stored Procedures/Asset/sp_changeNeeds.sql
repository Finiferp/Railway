use RailwayProject;
DELIMITER //
DROP PROCEDURE IF EXISTS sp_changeNeeds;
CREATE PROCEDURE sp_changeNeeds(IN assetId INT, assetLevel INT)
BEGIN
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
END //
DELIMITER ;