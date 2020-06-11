DROP TABLE IF EXISTS `t_goods_append_items`;
CREATE TABLE `t_goods_append_items` (
  `no` bigint(12) NOT NULL AUTO_INCREMENT,
  `itemId` varchar(10) NOT NULL,
  `classId` varchar(10) NOT NULL,
  `displayName` varchar(50) DEFAULT NULL,
  `fieldName` varchar(50) DEFAULT NULL,
  `fieldType` varchar(6) DEFAULT NULL,
  `fieldLength` int(8),
  `inputType` varchar(6) DEFAULT NULL,
  `defaultValue` varchar(500) DEFAULT NULL,
  `isRequired` char(1),
  `sortOrder` int(8),
  `openFlg` char(1) NOT NULL,
  `buyUseFlg` char(1),
  `addTimestamp` timestamp NULL DEFAULT NULL,
  `addUserKey` varchar(40) DEFAULT NULL,
  `updTimestamp` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updUserKey` varchar(40) DEFAULT NULL,
  `updPgmId` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
