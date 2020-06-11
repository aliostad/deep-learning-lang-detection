SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `core_DBversion` VALUES ('4', '0', '2', '2008-12-29 12:36:30');

ALTER TABLE `core_MessageMaster` ADD COLUMN `IsEmailOnComment` tinyint(4) NULL;

CREATE TABLE `core_UserReadMessages` (
  `UserID` int(10) unsigned NOT NULL,
  `MessageID` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`UserID`,`MessageID`),
  KEY `IDX_UserReadMessages_MessageID` (`MessageID`),
  CONSTRAINT `FK_UserReadMessages_UserMaster` FOREIGN KEY (`UserID`) REFERENCES `core_UserMaster` (`UserID`),
  CONSTRAINT `FK_UserReadMessgaes_MessageMaster` FOREIGN KEY (`MessageID`) REFERENCES `core_MessageMaster` (`MessageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
