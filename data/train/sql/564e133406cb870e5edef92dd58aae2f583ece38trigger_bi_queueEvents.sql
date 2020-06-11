/* This file redefines trigger bi_queueEvents for updating from versions that
   did not have queuename. */

USE asterisk;

DROP TRIGGER IF EXISTS `asterisk`.`bi_queueEvents`;
DELIMITER //
CREATE TRIGGER `asterisk`.`bi_queueEvents` BEFORE INSERT ON `asterisk`.`queue_log`
FOR EACH ROW BEGIN
IF NEW.event = 'ADDMEMBER' THEN
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid,queue) VALUES (NEW.agent,'READY',FROM_UNIXTIME(NEW.time),NULL,NEW.queuename) ON DUPLICATE KEY UPDATE agentStatus = "READY", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL, queue = NEW.queuename;
ELSEIF NEW.event = 'REMOVEMEMBER' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid,queue) VALUES (NEW.agent,'LOGGEDOUT',FROM_UNIXTIME(NEW.time),NULL,NEW.queuename) ON DUPLICATE KEY UPDATE agentStatus = "LOGGEDOUT", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL, queue = NEW.queuename;
ELSEIF NEW.event = 'AGENTLOGIN' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid,queue) VALUES (NEW.agent,'LOGGEDIN',FROM_UNIXTIME(NEW.time),NULL,NEW.queuename) ON DUPLICATE KEY UPDATE agentStatus = "LOGGEDIN", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL, queue = NEW.queuename;
ELSEIF NEW.event = 'AGENTLOGOFF' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid,queue) VALUES (NEW.agent,'LOGGEDOUT',FROM_UNIXTIME(NEW.time),NULL,NEW.queuename) ON DUPLICATE KEY UPDATE agentStatus = "LOGGEDOUT", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL, queue = NEW.queuename;
ELSEIF NEW.event = 'PAUSE' THEN
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid,queue) VALUES (NEW.agent,'PAUSE',FROM_UNIXTIME(NEW.time),NULL,NEW.queuename) ON DUPLICATE KEY UPDATE agentStatus = "PAUSE", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL, queue = NEW.queuename;
ELSEIF NEW.event = 'UNPAUSE' THEN
INSERT INTO `agent_status` (agentId,agentStatus,timestamp,callid,queue) VALUES (NEW.agent,'READY',FROM_UNIXTIME(NEW.time),NULL,NEW.queuename) ON DUPLICATE KEY UPDATE agentStatus = "READY", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL, queue = NEW.queuename;
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
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid,queue) VALUES
(NEW.agent,NEW.event,
FROM_UNIXTIME(NEW.time),
NEW.callid,
NEW.queuename)
ON DUPLICATE KEY UPDATE
agentStatus = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
callid = NEW.callid,
queue = NEW.queuename;
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
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid,queue) VALUES (NEW.agent,NEW.event,FROM_UNIXTIME(NEW.time),NULL,NEW.queuename) ON DUPLICATE KEY UPDATE agentStatus = "READY", timestamp = FROM_UNIXTIME(NEW.time), callid = NULL, queue = NEW.queuename;
ELSEIF NEW.event in ('TRANSFER') THEN
UPDATE `call_status` SET
callid = NEW.callid,
status = NEW.event,
timestamp = FROM_UNIXTIME(NEW.time),
queue = NEW.queuename,
holdtime = replace(substring(substring_index(NEW.data, '|', 1), length(substring_index(NEW.data, '|', 1 - 1)) + 1), '|', ''),
callduration = replace(substring(substring_index(NEW.data, '|', 3), length(substring_index(NEW.data, '|', 3 - 1)) + 1), '|', '')
where callid = NEW.callid;
INSERT INTO agent_status (agentId,agentStatus,timestamp,callid,queue) VALUES
(NEW.agent,'READY',FROM_UNIXTIME(NEW.time),NULL,NEW.queuename)
ON DUPLICATE KEY UPDATE
agentStatus = "READY",
timestamp = FROM_UNIXTIME(NEW.time),
callid = NULL,
queue = NEW.queuename;
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
