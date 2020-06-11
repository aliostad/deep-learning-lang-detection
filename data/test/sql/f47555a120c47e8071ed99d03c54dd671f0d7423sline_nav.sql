-- 表的结构：sline_nav --
CREATE TABLE `sline_nav` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `webid` int(11) unsigned DEFAULT '0' COMMENT '站点id',
  `aid` int(11) unsigned DEFAULT NULL COMMENT '弃用',
  `typeid` int(1) DEFAULT NULL COMMENT '栏目ID',
  `pid` smallint(6) unsigned DEFAULT '0' COMMENT '父栏目ID',
  `typename` varchar(255) DEFAULT NULL COMMENT '栏目名称',
  `shortname` varchar(255) DEFAULT NULL COMMENT '栏目名称简写',
  `seotitle` varchar(255) DEFAULT NULL COMMENT 'seo标题',
  `keyword` varchar(255) DEFAULT NULL COMMENT '关键词',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `jieshao` mediumtext COMMENT '栏目介绍',
  `tagword` varchar(255) DEFAULT NULL COMMENT 'tag词',
  `url` varchar(255) DEFAULT NULL COMMENT '链接url',
  `linktype` int(1) DEFAULT NULL COMMENT '1,站内链接,0:站外链接',
  `isopen` int(1) DEFAULT '1' COMMENT '是否开放1,开放,0关闭',
  `displayorder` int(5) DEFAULT '9999' COMMENT '排序',
  `issystem` int(1) unsigned DEFAULT '0' COMMENT '是否系统栏目',
  `linktitle` varchar(255) DEFAULT NULL COMMENT '链接指向文本',
  `isfinishseo` int(11) unsigned DEFAULT '0' COMMENT '是否完成优化',
  `shownum` int(2) DEFAULT '5' COMMENT '显示数量',
  `templetpath` varchar(255) DEFAULT NULL COMMENT '模板',
  `kind` tinyint(255) DEFAULT NULL COMMENT 'ico类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='主导航表';-- <xjx> --

