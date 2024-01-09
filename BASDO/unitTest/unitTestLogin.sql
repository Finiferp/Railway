SET @testReport = '';
SET @commonToken = 'test'; -- Change the token before UniTest
START TRANSACTION;

/*
---------------------------------------------------------------------
Test Case: TC01
	Description: Valid login with correct credentials.
	Expected return: Code 200
---------------------------------------------------------------------
*/
SET @pInJSON = '{"username": "Finiferp", "password": "797c9a8dfa9f66373d685144034bac324d275cd6831074a23a8c7f4324a6796fd5651c0368a9cb9b057b358569d4de1acc06033dac45747986d7145f5f50e1f04c1aa5a306d3a5ca30be4c862b118a20b562f2c68a1c3de79719c09fa571e4c6e0804794a4ade52b8d400118064654b03b16de4a063da3b5a3ef79158ab1856e0776d78fa1f483d1e18959bc8f42ab2fc902e5ee55be269906b836b73479def6de51b424309f9d7ecf34d087a3119e3ce017a9338bf7544c5ec3363086dc483198bceb54f527232a512c070d0cadeb37e95f4d2c40ac151f44be4b011699fdd4c9989597067e8ce9347606789dfeb6d87dccab6b624530a2cff8237c4cd464d52e2c0c4a0e6e159742f077cad10d8567ce09b47f8e6d5dc20adbff32d991124134ddc8a83cf8454ceeac3608f1d56c9de3a9c0c052aeeb426b65fc10008713b3f6eea5214517ccc6c51492e2e99f921d535e145c6b55d0b3e39c3dd7dbb3b30dce3bcf070bb0d774d1192056a213d903351974f46a97599c8c0c60403aa9798c5465cb9c5d2297d0ed98dfb017ee65cfd8cedea195faaabd238eb6c45e8bd7e1604be237773084dcfbcd91017d7eca0fad8f4540777caeb5addbfc2e0f040d3a2be327ea135023a08bcbd12e3b1491f44c4886542f7f6d223956057f061e9b8c3fd0f76f88841960276b89d1c12e6c0f09eddcaedb2d201d9d9f13d92bc73902", "token": "@commonToken"}';
SET @pOutJSON = '';
CALL sp_LoginCopy(@pInJSON, @pOutJSON);
SET @testReport = CONCAT(@testReport, "TC01: ", IF(@pOutJSON LIKE '%"status_code": 200%', "Yes", concat("No ", @pOutJSON)), CHAR(13));

/*
---------------------------------------------------------------------
Test Case: TC02
	Description: Valid login with incorrect password.
	Expected return: Code 401
---------------------------------------------------------------------
*/
SET @pInJSON = '{"username": "Finiferp", "password": "incorrectpassword", "token": "@commonToken"}';
SET @pOutJSON = '';
CALL sp_LoginCopy(@pInJSON, @pOutJSON);
SET @testReport = CONCAT(@testReport, "TC02: ", IF(@pOutJSON LIKE '%"status_code": 401%', "Yes", concat("No ", @pOutJSON)), CHAR(13));

/*
---------------------------------------------------------------------
Test Case: TC03
	Description: Login attempt with non-existing username.
	Expected return: Code 404
---------------------------------------------------------------------
*/
SET @pInJSON = '{"username": "nonexistentuser", "password": "797c9a8dfa9f66373d685144034bac324d275cd6831074a23a8c7f4324a6796fd5651c0368a9cb9b057b358569d4de1acc06033dac45747986d7145f5f50e1f04c1aa5a306d3a5ca30be4c862b118a20b562f2c68a1c3de79719c09fa571e4c6e0804794a4ade52b8d400118064654b03b16de4a063da3b5a3ef79158ab1856e0776d78fa1f483d1e18959bc8f42ab2fc902e5ee55be269906b836b73479def6de51b424309f9d7ecf34d087a3119e3ce017a9338bf7544c5ec3363086dc483198bceb54f527232a512c070d0cadeb37e95f4d2c40ac151f44be4b011699fdd4c9989597067e8ce9347606789dfeb6d87dccab6b624530a2cff8237c4cd464d52e2c0c4a0e6e159742f077cad10d8567ce09b47f8e6d5dc20adbff32d991124134ddc8a83cf8454ceeac3608f1d56c9de3a9c0c052aeeb426b65fc10008713b3f6eea5214517ccc6c51492e2e99f921d535e145c6b55d0b3e39c3dd7dbb3b30dce3bcf070bb0d774d1192056a213d903351974f46a97599c8c0c60403aa9798c5465cb9c5d2297d0ed98dfb017ee65cfd8cedea195faaabd238eb6c45e8bd7e1604be237773084dcfbcd91017d7eca0fad8f4540777caeb5addbfc2e0f040d3a2be327ea135023a08bcbd12e3b1491f44c4886542f7f6d223956057f061e9b8c3fd0f76f88841960276b89d1c12e6c0f09eddcaedb2d201d9d9f13d92bc73902", "token": "@commonToken"}';
SET @pOutJSON = '';
CALL sp_LoginCopy(@pInJSON, @pOutJSON);
SET @testReport = CONCAT(@testReport, "TC03: ", IF(@pOutJSON LIKE '%"status_code": 404%', "Yes", concat("No ", @pOutJSON)), CHAR(13));

/*
---------------------------------------------------------------------
Test Case: TC04
	Description: Invalid JSON format.
	Expected return: Code 400
---------------------------------------------------------------------
*/
SET @pInJSON = '{"invalid_key": "testvalue"}';
SET @pOutJSON = '';
CALL sp_LoginCopy(@pInJSON, @pOutJSON);
SET @testReport = CONCAT(@testReport, "TC04: ", IF(@pOutJSON LIKE '%"status_code": 400%', "Yes", concat("No ", @pOutJSON)), CHAR(13));


ROLLBACK;
SELECT @testReport;
