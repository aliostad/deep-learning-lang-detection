DROP TABLE IF EXISTS `{{contact}}`;
CREATE TABLE IF NOT EXISTS `{{contact}}` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `uid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `cuid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '常联系人id',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE,
  KEY `cuid` (`cuid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='常联系人表';

INSERT INTO `{{menu_common}}`( `module`, `name`, `url`, `description`, `sort`, `iscommon`) VALUES ('contact','通讯录','contact/default/index','提供企业员工通讯录','9','0');
INSERT INTO `{{nav}}`(`pid`, `name`, `url`, `targetnew`, `system`, `disabled`, `sort`, `module`) VALUES ('8','通讯录','contact/default/index','0','1','0','3','contact');
