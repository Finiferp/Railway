/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET SQL_NOTES=0 */;
DROP TABLE IF EXISTS `Asset`;
CREATE TABLE `Asset` (
  `idAsset_PK` int NOT NULL AUTO_INCREMENT,
  `name` varchar(450) NOT NULL,
  `type` enum('TOWN','RURALBUSINESS') NOT NULL,
  `population` int NOT NULL,
  `level` int NOT NULL,
  `stockpileMax` int NOT NULL,
  `idWorld_FK` int NOT NULL,
  `position` point NOT NULL,
  `idOwner_FK` int DEFAULT NULL,
  `cost` int NOT NULL DEFAULT '250000',
  PRIMARY KEY (`idAsset_PK`),
  KEY `idWorld_ExistsIn_FK_idx` (`idWorld_FK`),
  KEY `idOwner_FK_idx` (`idOwner_FK`),
  CONSTRAINT `idOwner_FK` FOREIGN KEY (`idOwner_FK`) REFERENCES `Player` (`idPlayer_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idWorld_ExistsIn_FK` FOREIGN KEY (`idWorld_FK`) REFERENCES `World` (`idWorld_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Connects`;
CREATE TABLE `Connects` (
  `idStation_Connects_FK` int NOT NULL,
  `idRailway_Connects_FK` int NOT NULL,
  PRIMARY KEY (`idStation_Connects_FK`,`idRailway_Connects_FK`),
  KEY `idRailway_Connects_FK_idx` (`idRailway_Connects_FK`),
  CONSTRAINT `idRailway_Connects_FK` FOREIGN KEY (`idRailway_Connects_FK`) REFERENCES `Railway` (`idRailway_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idStation_Connects_FK` FOREIGN KEY (`idStation_Connects_FK`) REFERENCES `Station` (`idStation_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Consumes`;
CREATE TABLE `Consumes` (
  `idIndustry_Consumes_PKFK` int NOT NULL,
  `idGood_Consumes_PKFK` int NOT NULL,
  PRIMARY KEY (`idIndustry_Consumes_PKFK`,`idGood_Consumes_PKFK`),
  KEY `idGood_Consumes_PKFK_idx` (`idGood_Consumes_PKFK`),
  CONSTRAINT `idGood_Consumes_PKFK` FOREIGN KEY (`idGood_Consumes_PKFK`) REFERENCES `Good` (`idGood_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idIndustry_Consumes_PKFK` FOREIGN KEY (`idIndustry_Consumes_PKFK`) REFERENCES `Industry` (`idIndustry_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Good`;
CREATE TABLE `Good` (
  `idGood_PK` int NOT NULL AUTO_INCREMENT,
  `name` varchar(450) NOT NULL,
  PRIMARY KEY (`idGood_PK`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Industry`;
CREATE TABLE `Industry` (
  `idIndustry_PK` int NOT NULL AUTO_INCREMENT,
  `name` varchar(450) NOT NULL,
  `warehouseCapacity` int NOT NULL DEFAULT '0',
  `idAsset_FK` int NOT NULL,
  `type` enum('BREWERY','BUTCHER','BAKERY','SAWMILL','CHEESEMAKER','CARPENTER','TAILOR','SMELTER','SMITHY','JEWELER') NOT NULL,
  `idGood_Produce_FK` int NOT NULL,
  `cost` int NOT NULL DEFAULT '500000',
  `upkeepcost` int NOT NULL DEFAULT '500',
  PRIMARY KEY (`idIndustry_PK`),
  KEY `idAsset_belongsTo_FK_idx` (`idAsset_FK`),
  KEY `idGood_Produce_FK_idx` (`idGood_Produce_FK`),
  CONSTRAINT `idAsset_belongsTo_FK` FOREIGN KEY (`idAsset_FK`) REFERENCES `Asset` (`idAsset_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idGood_Produce_FK` FOREIGN KEY (`idGood_Produce_FK`) REFERENCES `Good` (`idGood_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Makes`;
CREATE TABLE `Makes` (
  `idGood_Makes_PKFK` int NOT NULL,
  `idAsset_Makes_PKFK` int NOT NULL,
  PRIMARY KEY (`idGood_Makes_PKFK`,`idAsset_Makes_PKFK`),
  KEY `idAsset_Makes_PKFK_idx` (`idAsset_Makes_PKFK`),
  CONSTRAINT `idAsset_Makes_PKFK` FOREIGN KEY (`idAsset_Makes_PKFK`) REFERENCES `Asset` (`idAsset_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idGood_Makes_PKFK` FOREIGN KEY (`idGood_Makes_PKFK`) REFERENCES `Good` (`idGood_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Needs`;
CREATE TABLE `Needs` (
  `idAsset_Needs_PKFK` int NOT NULL,
  `idGood_Needs_PKFK` int NOT NULL,
  `consumption` float NOT NULL,
  PRIMARY KEY (`idAsset_Needs_PKFK`,`idGood_Needs_PKFK`),
  KEY `idGood_Needs_PKFK_idx` (`idGood_Needs_PKFK`),
  CONSTRAINT `idAsset_Needs_PKFK` FOREIGN KEY (`idAsset_Needs_PKFK`) REFERENCES `Asset` (`idAsset_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idGood_Needs_PKFK` FOREIGN KEY (`idGood_Needs_PKFK`) REFERENCES `Good` (`idGood_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Player`;
CREATE TABLE `Player` (
  `idPlayer_PK` int NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL,
  `password` varchar(10000) NOT NULL,
  `salt` varchar(450) NOT NULL,
  `idWorld_FK` int NOT NULL,
  `funds` bigint NOT NULL DEFAULT '500000',
  PRIMARY KEY (`idPlayer_PK`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  KEY `idWorld_PlaysIn_FK_idx` (`idWorld_FK`),
  CONSTRAINT `idWorld_PlaysIn_FK` FOREIGN KEY (`idWorld_FK`) REFERENCES `World` (`idWorld_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Railway`;
CREATE TABLE `Railway` (
  `idRailway_PK` int NOT NULL AUTO_INCREMENT,
  `distance` int DEFAULT NULL,
  PRIMARY KEY (`idRailway_PK`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Station`;
CREATE TABLE `Station` (
  `idStation_PK` int NOT NULL AUTO_INCREMENT,
  `name` varchar(450) NOT NULL,
  `cost` int NOT NULL DEFAULT '100000',
  `operationCost` int NOT NULL DEFAULT '1000',
  `idAsset_FK` int NOT NULL,
  PRIMARY KEY (`idStation_PK`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `idAsset_Owns_PKFK_idx` (`idAsset_FK`),
  CONSTRAINT `idAsset_Owns_PKFK` FOREIGN KEY (`idAsset_FK`) REFERENCES `Asset` (`idAsset_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Stockpiles`;
CREATE TABLE `Stockpiles` (
  `idAsset_Stockpiles_PKFK` int NOT NULL,
  `idGoodt_Stockpiles_PKFK` int NOT NULL,
  `quantity` bigint DEFAULT '0',
  PRIMARY KEY (`idAsset_Stockpiles_PKFK`,`idGoodt_Stockpiles_PKFK`),
  KEY `idGood_Stockpiles_PKFK_idx` (`idGoodt_Stockpiles_PKFK`),
  CONSTRAINT `idAsset_Stockpiles_PKFK` FOREIGN KEY (`idAsset_Stockpiles_PKFK`) REFERENCES `Asset` (`idAsset_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idGood_Stockpiles_PKFK` FOREIGN KEY (`idGoodt_Stockpiles_PKFK`) REFERENCES `Good` (`idGood_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Token`;
CREATE TABLE `Token` (
  `idTokens_PK` int NOT NULL AUTO_INCREMENT,
  `type` varchar(450) DEFAULT NULL,
  `idPlayer_Identifies_FK` int NOT NULL,
  PRIMARY KEY (`idTokens_PK`),
  KEY `idPlayer_Identifies_FK_idx` (`idPlayer_Identifies_FK`),
  CONSTRAINT `idPlayer_Identifies_FK` FOREIGN KEY (`idPlayer_Identifies_FK`) REFERENCES `Player` (`idPlayer_PK`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Train`;
CREATE TABLE `Train` (
  `idTrain_PK` int NOT NULL AUTO_INCREMENT,
  `name` varchar(450) NOT NULL,
  `cost` int NOT NULL DEFAULT '50000',
  `operationalCost` int NOT NULL DEFAULT '500',
  `traveledDistance` int NOT NULL DEFAULT '0',
  `idRailway_FK` int NOT NULL,
  `idAsset_Starts_FK` int NOT NULL,
  `idAsset_Destines_FK` int NOT NULL,
  `willReturnWithGoods` tinyint NOT NULL DEFAULT '0',
  `isReturning` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`idTrain_PK`),
  KEY `idRailway_Carries_FK_idx` (`idRailway_FK`),
  KEY `idAsset_Starts_FK_idx` (`idAsset_Starts_FK`),
  KEY `idAsset_Destines_FK_idx` (`idAsset_Destines_FK`),
  CONSTRAINT `idAsset_Destines_FK` FOREIGN KEY (`idAsset_Destines_FK`) REFERENCES `Asset` (`idAsset_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idAsset_Starts_FK` FOREIGN KEY (`idAsset_Starts_FK`) REFERENCES `Asset` (`idAsset_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idRailway_Carries_FK` FOREIGN KEY (`idRailway_FK`) REFERENCES `Railway` (`idRailway_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `Wagon`;
CREATE TABLE `Wagon` (
  `idWagon_PK` int NOT NULL AUTO_INCREMENT,
  `idTrain_FK` int NOT NULL,
  `idGood_Transport_FK` int NOT NULL,
  PRIMARY KEY (`idWagon_PK`),
  KEY `idTrain_Pulls_FK_idx` (`idTrain_FK`),
  KEY `idGood_Transport_FK_idx` (`idGood_Transport_FK`),
  CONSTRAINT `idGood_Transport_FK` FOREIGN KEY (`idGood_Transport_FK`) REFERENCES `Good` (`idGood_PK`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idTrain_Pulls_FK` FOREIGN KEY (`idTrain_FK`) REFERENCES `Train` (`idTrain_PK`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `World`;
CREATE TABLE `World` (
  `idWorld_PK` int NOT NULL AUTO_INCREMENT,
  `creationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idWorld_PK`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;