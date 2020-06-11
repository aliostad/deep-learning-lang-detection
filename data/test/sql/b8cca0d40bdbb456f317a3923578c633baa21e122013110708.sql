--
-- 表的结构 `car_type_tbl`
--

CREATE TABLE IF NOT EXISTS `car_type_tbl` (
  `type_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `status` tinyint(1) NOT NULL COMMENT '0开启，1关闭',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='分类表' AUTO_INCREMENT=1 ;



--
-- 表的结构 `topic_image_tbl`
--

CREATE TABLE IF NOT EXISTS `topic_image_tbl` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `type_id` smallint(6) NOT NULL COMMENT '分类id',
  `name` varchar(20) NOT NULL COMMENT '图片名称',
  `image_url` varchar(256) NOT NULL COMMENT '图片地址',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0启用，1禁用',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_time` datetime NOT NULL COMMENT '创建',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='模块图片表' AUTO_INCREMENT=1 ;



--
-- 表的结构 `topic_nav_tbl`
--

CREATE TABLE IF NOT EXISTS `topic_nav_tbl` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '导航id',
  `type_id` smallint(6) NOT NULL COMMENT '分类id',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `description` varchar(512) NOT NULL COMMENT '描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0开启，1关闭',
  `media_url` varchar(512) NOT NULL COMMENT '视频，或图片',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='导航模块表' AUTO_INCREMENT=1 ;



