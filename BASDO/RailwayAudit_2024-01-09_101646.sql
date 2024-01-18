/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET SQL_NOTES=0 */;
DROP TABLE IF EXISTS `AssetAudit`;
CREATE TABLE `AssetAudit` (
  `idAssetAudit` int NOT NULL AUTO_INCREMENT,
  `idAsset_PK` int DEFAULT NULL,
  `name` varchar(450) DEFAULT NULL,
  `type` enum('TOWN','RURALBUSINESS') DEFAULT NULL,
  `population` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `stockpileMax` int DEFAULT NULL,
  `idWorld_FK` int DEFAULT NULL,
  `position` point DEFAULT NULL,
  `idOwner_FK` int DEFAULT NULL,
  `cost` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idAssetAudit`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ConnectsAudit`;
CREATE TABLE `ConnectsAudit` (
  `idConnectsAudit` int NOT NULL AUTO_INCREMENT,
  `idStation_Connects_FK` int DEFAULT NULL,
  `idRailway_Connects_FK` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idConnectsAudit`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ConsumesAudit`;
CREATE TABLE `ConsumesAudit` (
  `idConsumesAudit` int NOT NULL AUTO_INCREMENT,
  `idIndustry_Consumes_PKFK` int DEFAULT NULL,
  `idGood_Consumes_PKFK` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idConsumesAudit`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `GoodAudit`;
CREATE TABLE `GoodAudit` (
  `idGoodAudit` int NOT NULL AUTO_INCREMENT,
  `idGood_PK` int DEFAULT NULL,
  `name` varchar(450) DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idGoodAudit`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `IndustryAudit`;
CREATE TABLE `IndustryAudit` (
  `idIndustryAudit` int NOT NULL AUTO_INCREMENT,
  `idIndustry_PK` int DEFAULT NULL,
  `name` varchar(450) DEFAULT NULL,
  `warehouseCapacity` int DEFAULT NULL,
  `idAsset_FK` int DEFAULT NULL,
  `type` enum('BREWERY','BUTCHER','BAKERY','SAWMILL','CHEESEMAKER','CARPENTER','TAILOR','SMELTER','SMITHY','JEWELER') DEFAULT NULL,
  `idGood_Produce_FK` int DEFAULT NULL,
  `cost` int DEFAULT NULL,
  `upkeepcost` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idIndustryAudit`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `MakesAudit`;
CREATE TABLE `MakesAudit` (
  `idMakesAudit` int NOT NULL AUTO_INCREMENT,
  `idGood_Makes_PKFK` int DEFAULT NULL,
  `idAsset_Makes_PKFK` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idMakesAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `NeedsAudit`;
CREATE TABLE `NeedsAudit` (
  `idNeedsAudit` int NOT NULL AUTO_INCREMENT,
  `idAsset_Needs_PKFK` int DEFAULT NULL,
  `idGood_Needs_PKFK` int DEFAULT NULL,
  `consumption` float DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idNeedsAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `PlayeAudit`;
CREATE TABLE `PlayeAudit` (
  `idPlayeAudit` int NOT NULL AUTO_INCREMENT,
  `idPlayer_PK` int DEFAULT NULL,
  `username` varchar(80) DEFAULT NULL,
  `password` varchar(10000) DEFAULT NULL,
  `salt` varchar(450) DEFAULT NULL,
  `idWorld_FK` int DEFAULT NULL,
  `funds` bigint DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idPlayeAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `RailwayAudit`;
CREATE TABLE `RailwayAudit` (
  `idRailwayAudit` int NOT NULL AUTO_INCREMENT,
  `idRailway_PK` int DEFAULT NULL,
  `distance` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idRailwayAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `StationAudit`;
CREATE TABLE `StationAudit` (
  `idStationAudit` int NOT NULL AUTO_INCREMENT,
  `idStation_PK` int DEFAULT NULL,
  `name` varchar(450) DEFAULT NULL,
  `cost` int DEFAULT NULL,
  `operationCost` int DEFAULT NULL,
  `idAsset_FK` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idStationAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `StockpilesAudit`;
CREATE TABLE `StockpilesAudit` (
  `idStockpilesAudit` int NOT NULL AUTO_INCREMENT,
  `idAsset_Stockpiles_PKFK` int DEFAULT NULL,
  `idGoodt_Stockpiles_PKFK` int DEFAULT NULL,
  `quantity` bigint DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idStockpilesAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `TrainAudit`;
CREATE TABLE `TrainAudit` (
  `idTrainAudit` int NOT NULL AUTO_INCREMENT,
  `idTrain_PK` int DEFAULT NULL,
  `name` varchar(450) DEFAULT NULL,
  `cost` int DEFAULT NULL,
  `operationalCost` int DEFAULT NULL,
  `traveledDistance` int DEFAULT NULL,
  `idRailway_FK` int DEFAULT NULL,
  `idAsset_Starts_FK` int DEFAULT NULL,
  `idAsset_Destines_FK` int DEFAULT NULL,
  `willReturnWithGoods` int DEFAULT NULL,
  `isReturning` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idTrainAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `WagonAudit`;
CREATE TABLE `WagonAudit` (
  `idWagonAudit` int NOT NULL AUTO_INCREMENT,
  `idWagon_PK` int DEFAULT NULL,
  `idTrain_FK` int DEFAULT NULL,
  `idGood_Transport_FK` int DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idWagonAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `WorldAudit`;
CREATE TABLE `WorldAudit` (
  `idWorldAudit` int NOT NULL AUTO_INCREMENT,
  `idWorld_PK` int DEFAULT NULL,
  `creationDate` datetime DEFAULT NULL,
  `audit_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `audit_action` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`idWorldAudit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;