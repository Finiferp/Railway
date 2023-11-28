DELIMITER //
DROP PROCEDURE IF EXISTS sp_createIndustry;
CREATE PROCEDURE sp_createIndustry(IN json_data JSON)
BEGIN
    DECLARE input_name VARCHAR(450);
    DECLARE input_id_asset INT;
    DECLARE input_type ENUM('BREWERY','BUTCHER','BAKERY','SAWMILL','CHEESEMAKER','CARPENTER','TAILOR','SMELTER','SMITHY','JEWELER');
    DECLARE new_industry_id INT;
    DECLARE response_code INT;
    DECLARE response_message VARCHAR(255);

    -- Extracting data from JSON input
    SET input_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.name'));
    SET input_id_asset = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.idAsset'));
    SET input_type = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.type'));

    -- Insert data into Consumes table based on industry type
    CASE input_type
        WHEN 'BREWERY' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 2);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 1);
        WHEN 'BUTCHER' THEN
            INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 12);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 21);
		WHEN 'BAKERY' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 13);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 3);
		WHEN 'SAWMILL' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 6);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 4);
		WHEN 'CHEESEMAKER' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 15);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 5);
       WHEN 'CARPENTER' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 16);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 6);
			INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 23);
		WHEN 'TAILOR' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 17);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 4);
			INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 23);
		WHEN 'SMELTER' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 18);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 8);
		WHEN 'SMITHY' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 19);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 18);
		WHEN 'JEWLER' THEN
			INSERT INTO Industry (name, idAsset_FK, type, idGood_Produce_FK) VALUES (input_name, input_id_asset, input_type, 20);
			SET new_industry_id = LAST_INSERT_ID();
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 19);
            INSERT INTO Consumes (idIndustry_Consumes_PKFK, idGood_Consumes_PKFK) VALUES (new_industry_id, 11);
    END CASE;

    -- Set response code and message
    IF new_industry_id IS NOT NULL THEN
        SET response_code = 201;
        SET response_message = 'Industry created successfully';
    ELSE
        SET response_code = 400;
        SET response_message = 'Failed to create industry';
    END IF;

    -- Return the JSON response
    SELECT 
        CASE
            WHEN response_code = 201 THEN
                JSON_OBJECT('status_code', response_code, 'message', response_message, 'industry', 
                    JSON_OBJECT('id', new_industry_id, 'name', input_name, 'type', input_type, 'idAsset', input_id_asset))
            ELSE
                JSON_OBJECT('status_code', response_code, 'message', response_message)
        END AS 'result';

END //

DELIMITER ;
