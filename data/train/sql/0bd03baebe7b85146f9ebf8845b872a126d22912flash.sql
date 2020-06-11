CREATE TABLE `flash` (
    `id` INT(11) NOT NULL  AUTO_INCREMENT,
    `onlinedate`    DATE        NOT NULL  COMMENT '闪购日期',
    `itemid`        INT(11)     NOT NULL  COMMENT '商品ID',
    `starttime`     DATETIME              COMMENT '开始时间',
    `endtime`       DATETIME              COMMENT '结束时间',
    `status`        TINYINT(4)    DEFAULT 0 COMMENT '状态',
    `croweds`       varchar(255)    COMMENT '适用人群',
    `gender`        tinyint(4)                COMMENT '适用性别',
    `priority`        INT(11)        NOT NULL default 0 comment '优先级',
    `createtime`    DATETIME              COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_itemid` (`itemid`),
  KEY `idx_status` (`status`),
  UNIQUE KEY `uidx_onlinedate_itemid` (`onlinedate`,`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='闪购';

CREATE TABLE `flash_index` (
    `id` int(11) not null primary key auto_increment,
    `status` int(11) not null comment '状态',
    `crowed` int(11) not null comment '适用人群',
    `gender` int(11) not null comment '性别',
    `priority` int(11) not null '优先级',
    `flash_id` int(11) not null '闪购编号',
    key `idx_status_crowed_gender_priority` (`status`, `crowed`, `gender`, `priority`),
    key `idx_flashid` (`flash_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='闪购索引表';