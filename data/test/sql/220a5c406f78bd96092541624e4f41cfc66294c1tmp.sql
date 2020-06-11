-- 清算临时表
CREATE TABLE `settle_temp3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `batchNumber` int(11) NOT NULL COMMENT '批次号',
  `cvid` int(11) NOT NULL DEFAULT '0',
  `settleDate` date NOT NULL COMMENT '清算日期',
  `acquirer_code` varchar(30) NOT NULL COMMENT '机构代码',
  `transDate` date NOT NULL COMMENT '交易日期',
  `transTime` time NOT NULL COMMENT '交易时间',
  `mid` varchar(50) DEFAULT NULL COMMENT '商编',
  `tid` varchar(30) DEFAULT NULL COMMENT '终端号',
  `transType` varchar(20) NOT NULL COMMENT '交易类型',
  `transAmt` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '交易金额',
  `acquirerFee` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '手续费',
  `settleAmt` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '第三方清算金额',
  `cvFee` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '卡得手续费',
  `cvSettleAmt` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '卡得清算金额',
  `serialNumber` varchar(50) NOT NULL COMMENT '流水号',
  `cardNo` varchar(30) DEFAULT NULL COMMENT '卡号',
  `cardType` varchar(20) DEFAULT NULL COMMENT '卡类型',
  `cardBank` varchar(100) DEFAULT NULL COMMENT '发卡行',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq` (`settleDate`,`mid`,`tid`,`serialNumber`),
  KEY `index1` (`settleDate`),
  KEY `index2` (`mid`),
  KEY `index3` (`transDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 解析流水文件所需字段位置信息表
CREATE TABLE `file_read_position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acquirer_code` varchar(30) NOT NULL COMMENT '机构代码',
  `header_offset` int(11) NOT NULL COMMENT '头偏移',
  `tail_offset` int(11) NOT NULL COMMENT '尾偏移',
  `file_type` varchar(10) NOT NULL COMMENT '文件类型',
  `file_encoding` varchar(10) NOT NULL COMMENT '文件编码方式',
  `row_split_regex` varchar(10) DEFAULT NULL COMMENT '文本文件行字段分隔符',
  `settle_date_pattern` varchar(20) NOT NULL DEFAULT 'yyyy-MM-dd' COMMENT '清算日期模式',
  `trans_date_pattern` varchar(20) NOT NULL DEFAULT 'yyyy-MM-dd' COMMENT '交易日期模式',
  `trans_time_pattern` varchar(20) NOT NULL DEFAULT 'HH:mm:ss' COMMENT '交易时间模式',
  `settle_date_pos` varchar(20) NOT NULL COMMENT '清算日期位置',
  `trans_date_pos` int(6) NOT NULL COMMENT '交易日期位置',
  `trans_time_pos` int(6) NOT NULL COMMENT '交易时间位置',
  `mid_pos` int(6) NOT NULL COMMENT '商编位置',
  `tid_pos` int(6) NOT NULL DEFAULT '0' COMMENT '终端号位置',
  `trans_type_pos` int(6) NOT NULL COMMENT '交易类型位置',
  `trans_amt_pos` int(6) NOT NULL DEFAULT '0' COMMENT '交易金额位置',
  `fee_pos` int(6) NOT NULL DEFAULT '0' COMMENT '手续费位置',
  `settle_amt_pos` int(6) NOT NULL COMMENT '第三方清算金额位置',
  `serial_number_pos` int(6) NOT NULL COMMENT '流水号位置',
  `card_no_pos` int(6) NOT NULL COMMENT '卡号位置',
  `card_type_pos` int(6) NOT NULL DEFAULT '0' COMMENT '卡类型位置',
  `card_bank_pos` int(6) NOT NULL DEFAULT '0' COMMENT '发卡行位置',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;


-- 流水文件格式数据
INSERT INTO file_read_position VALUES (NULL, '湖北', 1, 0, 'txt', 'gbk', '|', 'yyyyMMdd', 'MMdd', 'HHmmss', '3', 4, 5, 1, 6, 8, 9, 11, 10, 12, 7, 0, 13);
INSERT INTO file_read_position VALUES (NULL, '河北', 1, 0, 'txt', 'utf-8', '|', 'yyyyMMdd', 'MMdd', 'HHmmss', '3', 4, 5, 1, 6, 8, 9, 11, 10, 12, 7, 13, 14);
INSERT INTO file_read_position VALUES (NULL, '天津', 1, 0, 'txt', 'gbk', '|', 'yyyyMMdd', 'MMdd', 'HHmmss', '3', 4, 5, 1, 6, 8, 9, 11, 10, 12, 7, 0, 13);
INSERT INTO file_read_position VALUES (NULL, '安徽', 1, 0, 'txt', 'gbk', '|', 'yyyyMMdd', 'MMdd', 'HHmmss', '3', 4, 5, 1, 6, 8, 9, 11, 10, 12, 7, 13, 14);
INSERT INTO file_read_position VALUES (NULL, '内蒙', 0, 0, 'txt', 'gbk', '|', 'yyyyMMdd', 'MMdd', 'HHmmss', '3', 4, 5, 1, 6, 8, 9, 11, 10, 12, 7, 0, 13);
INSERT INTO file_read_position VALUES (NULL, '沈阳', 0, 0, 'txt', 'gbk', ',', 'yyyyMMdd', 'yyyyMMdd', 'HH:mm:ss', '1', 2, 3, 14, 4, 6, 7, 9, 8, 12, 5, 11, 13);
INSERT INTO file_read_position VALUES (NULL, '贵州', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '大连新', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '福建', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '甘肃', 4, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '1', 2, 3, 4, 5, 11, 7, 9, 8, 10, 12, 0, 13);
INSERT INTO file_read_position VALUES (NULL, '广西', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '广州', 1, 0, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '1', 4, 5, 2, 6, 7, 8, 9, 10, 11, 0, 0, 0);
INSERT INTO file_read_position VALUES (NULL, '河南', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '黑龙江', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '湖南', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '吉林', 4, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '1', 2, 3, 12, 4, 9, 5, 7, 6, 8, 10, 0, 11);
INSERT INTO file_read_position VALUES (NULL, '江苏', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '江西', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '宁夏', 4, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '1', 2, 3, 4, 5, 10, 6, 8, 7, 9, 11, 0, 12);
INSERT INTO file_read_position VALUES (NULL, '厦门', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '山东', 3, 4, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '2,6', 2, 3, 1, 4, 6, 7, 9, 8, 10, 5, 11, 12);
INSERT INTO file_read_position VALUES (NULL, '山西', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '陕西', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '2,6', 2, 3, 1, 4, 5, 7, 9, 8, 10, 6, 12, 13);
INSERT INTO file_read_position VALUES (NULL, '深圳', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '四川', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '银盛', 1, 0, 'xls', '', '', 'yyyyMMdd', 'yyyyMMddHHmmss', 'yyyyMMddHHmmss', '1', 13, 13, 4, 3, 9, 12, 0, 18, 2, 11, 15, 0);
INSERT INTO file_read_position VALUES (NULL, '云南', 3, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '3', 4, 5, 1, 0, 6, 0, 0, 8, 9, 7, 0, 10);
INSERT INTO file_read_position VALUES (NULL, '浙江', 3, 0, 'xls', '', '', 'yyyy-MM-dd', 'MMddHHmmss', 'MMddHHmmss', '1', 7, 7, 2, 3, 5, 8, 9, 0, 12, 10, 13, 4);
INSERT INTO file_read_position VALUES (NULL, '重庆', 4, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '1', 2, 3, 12, 4, 9, 5, 7, 6, 8, 11, 0, 14);
INSERT INTO file_read_position VALUES (NULL, '北京', 1, 0, 'xlsx', '', '', 'yyyy/MM/dd', 'yyyy/MM/dd HH:mm:ss', 'yyyy/MM/dd HH:mm:ss', '2', 3, 3, 4, 7, 10, 13, 14, 15, 8, 11, 0, 12);
INSERT INTO file_read_position VALUES (NULL, '新疆', 4, 2, 'xls', '', '', 'yyyyMMdd', 'yyyy-MM-dd', 'HH:mm:ss', '2', 3, 4, 5, 6, 11, 7, 9, 8, 10, 12, 0, 13);
