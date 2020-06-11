USE asterisk;

--
-- Triggers `queue_log`
--
DROP TRIGGER IF EXISTS `asterisk`.`update_processed`;
DELIMITER //
CREATE TRIGGER `asterisk`.`update_processed` AFTER INSERT ON `asterisk`.`queue_log`
FOR EACH ROW BEGIN
INSERT INTO queue_log_processed (origid,callid,queuename,agentdev,event,data1,data2,data3,datetime)
VALUES (
NEW.id,NEW.callid,NEW.queuename,NEW.agent,NEW.event,
replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', ''),
replace(substring(substring_index(NEW.data, '|', 2), length(substring_index(NEW.data, '|', 2 - 1)) + 1), '|', ''),
replace(substring(substring_index(NEW.data, '|', 3), length(substring_index(NEW.data, '|', 3 - 1)) + 1), '|', ''),
FROM_UNIXTIME(NEW.time)
);
END
//
DELIMITER ;

DROP TRIGGER IF EXISTS `asterisk`.`bi_queueEvents`;
DELIMITER //
CREATE TRIGGER `asterisk`.`bi_queueEvents` BEFORE INSERT ON `asterisk`.`queue_log`
FOR EACH ROW BEGIN
IF NEW.event = 'ADDMEMBER' THEN
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid) VALUES (NEW.agent,'READY',FROM_UNIXTIME(NEW.time),NULL) ON DUPLICATE KEY UPDATE agentStatus = "READY", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL;
ELSEIF NEW.event = 'REMOVEMEMBER' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid) VALUES (NEW.agent,'LOGGEDOUT',FROM_UNIXTIME(NEW.time),NULL) ON DUPLICATE KEY UPDATE agentStatus = "LOGGEDOUT", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL;
ELSEIF NEW.event = 'AGENTLOGIN' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid) VALUES (NEW.agent,'LOGGEDIN',FROM_UNIXTIME(NEW.time),NULL) ON DUPLICATE KEY UPDATE agentStatus = "LOGGEDIN", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL;
ELSEIF NEW.event = 'AGENTLOGOFF' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid) VALUES (NEW.agent,'LOGGEDOUT',FROM_UNIXTIME(NEW.time),NULL) ON DUPLICATE KEY UPDATE agentStatus = "LOGGEDOUT", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL;
ELSEIF NEW.event = 'PAUSE' THEN
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid) VALUES (NEW.agent,'PAUSE',FROM_UNIXTIME(NEW.time),NULL) ON DUPLICATE KEY UPDATE agentStatus = "PAUSE", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL;
ELSEIF NEW.event = 'UNPAUSE' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid) VALUES (NEW.agent,'READY',FROM_UNIXTIME(NEW.time),NULL) ON DUPLICATE KEY UPDATE agentStatus = "READY", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL;
ELSEIF NEW.event = 'ENTERQUEUE' THEN
REPLACE INTO `call_status` VALUES
(NEW.callid,
replace(replace(substring(substring_index(NEW.data, '|', 2), length(substring_index(New.data, '|', 2 - 1)) + 1), '|', '')
, '|', ''),
'inQue',
FROM_UNIXTIME(NEW.time),
NEW.queuename,
'',
'',
'',
'',
0);
ELSEIF NEW.event = 'CONNECT' THEN
UPDATE `call_status` SET
callid = NEW.callid,
status = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
queue = NEW.queuename,
holdtime = replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', '')
where callid = NEW.callid;
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid) VALUES
(NEW.agent,NEW.event,
FROM_UNIXTIME(NEW.time),
NEW.callid)
ON DUPLICATE KEY UPDATE
agentStatus = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
callid = NEW.callid;
ELSEIF NEW.event in ('COMPLETECALLER','COMPLETEAGENT') THEN
UPDATE `call_status` SET
callid = NEW.callid,
status = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
queue = NEW.queuename,
originalPosition = replace(substring(substring_index(NEW.data, '|', 3), length(substring_index(NEW.data, '|', 3 - 1)) + 1), '|', ''),
holdtime = replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', ''),
callduration = replace(substring(substring_index(NEW.data, '|', 2), length(substring_index(NEW.data, '|', 2 - 1)) + 1), '|', '')
where callid = NEW.callid;
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid) VALUES (NEW.agent,NEW.event,FROM_UNIXTIME(NEW.time),NULL) ON DUPLICATE KEY UPDATE agentStatus = "READY", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL;
ELSEIF NEW.event in ('TRANSFER') THEN
UPDATE `call_status` SET
callid = NEW.callid,
status = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
queue = NEW.queuename,
holdtime = replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', ''),
callduration = replace(substring(substring_index(NEW.data, '|', 3), length(substring_index(NEW.data, '|', 3 - 1)) + 1), '|', '')
where callid = NEW.callid;
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid) VALUES
(NEW.agent,'READY',FROM_UNIXTIME(NEW.time),NULL)
ON DUPLICATE KEY UPDATE
agentStatus = "READY",
timestamp = FROM_UNIXTIME(NEW.time),
callid = NULL;
ELSEIF NEW.event in ('ABANDON','EXITEMPTY') THEN
UPDATE `call_status` SET
callid = NEW.callid,
status = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
queue = NEW.queuename,
position = replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', ''),
originalPosition = replace(substring(substring_index(NEW.data, '|', 2), length(substring_index(NEW.data, '|', 2 - 1)) + 1), '|', ''),
holdtime = replace(substring(substring_index(NEW.data, '|', 3), length(substring_index(NEW.data, '|', 3 - 1)) + 1), '|', '')
where callid = NEW.callid;
ELSEIF NEW.event = 'EXITWITHKEY'THEN
UPDATE `call_status` SET
callid = NEW.callid,
status = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
queue = NEW.queuename,
position = replace(substring(substring_index(NEW.data, '|', 2), length(substring_index(NEW.data, '|', 2 - 1)) + 1), '|', ''),
keyPressed = replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', '')
where callid = NEW.callid;
ELSEIF NEW.event = 'EXITWITHTIMEOUT' THEN
UPDATE `call_status` SET
callid = NEW.callid,
status = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
queue = NEW.queuename,
position = replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', '')
where callid = NEW.callid;
END IF;
END
//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `agent_status` (
`agentId` varchar(40) NOT NULL default '',
`agentName` varchar(40) default NULL,
`agentStatus` varchar(30) default NULL,
`timestamp` timestamp NULL default NULL,
`callid` double(18,6) unsigned default '0.000000',
`queue` varchar(20) default NULL,
PRIMARY KEY (`agentId`),
KEY `agentName` (`agentName`),
KEY `agentStatus` (`agentStatus`,`timestamp`,`callid`),
KEY `queue` (`queue`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `call_status` (
`callId` double(18,6) NOT NULL,
`callerId` varchar(13) NOT NULL,
`status` varchar(30) NOT NULL,
`timestamp` timestamp NULL default NULL,
`queue` varchar(25) NOT NULL,
`position` varchar(11) NOT NULL,
`originalPosition` varchar(11) NOT NULL,
`holdtime` varchar(11) NOT NULL,
`keyPressed` varchar(11) NOT NULL,
`callduration` int(11) NOT NULL,
PRIMARY KEY (`callId`),
KEY `callerId` (`callerId`),
KEY `status` (`status`),
KEY `timestamp` (`timestamp`),
KEY `queue` (`queue`),
KEY `position` (`position`,`originalPosition`,`holdtime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

