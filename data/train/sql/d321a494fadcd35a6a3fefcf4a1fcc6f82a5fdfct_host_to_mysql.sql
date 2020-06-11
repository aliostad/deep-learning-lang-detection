SET NAMES UTF8;
USE db_itl;

delimiter :
--t_host_info的mysql信息同步到t_mysql_error_log_info,t_mysql_locked_processlist,t_mysql_innodb_deadlock_event
DROP TRIGGER IF EXISTS tr_host_to_mysql_add:
CREATE TRIGGER tr_host_to_mysql_add AFTER INSERT ON t_host_info 
FOR EACH ROW
BEGIN
IF(NEW.metric_name='last_log_error') THEN
INSERT IGNORE INTO t_mysql_error_log_info(mysql_host, mysql_port, line_num, error_time, error_content)\
VALUES(NEW.host_name, NEW.metric_arg, SUBSTRING_INDEX(NEW.metric_val,':',1), \
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val,':',2),':',-1),\
RIGHT(NEW.metric_val, length(NEW.metric_val) - length(SUBSTRING_INDEX(NEW.metric_val,':',2)) - 1));
END IF;
IF(NEW.metric_name='last_locked_processlist') THEN
INSERT IGNORE INTO t_mysql_locked_processlist(add_time,mysql_host,mysql_port,process_id,process_user,process_host,process_time,process_info) \
VALUES(UNIX_TIMESTAMP(NOW()),NEW.host_name, NEW.metric_arg,\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-5),';',1),\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-4),';',1),\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-3),';',1),\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-2),';',1),\
SUBSTRING_INDEX(NEW.metric_val ,';',-1)) ON DUPLICATE KEY UPDATE process_time=SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-2),';',1);
END IF;
IF(NEW.metric_name='innodb_deadlock_event') THEN
INSERT IGNORE INTO t_mysql_innodb_deadlock_event(mysql_host, mysql_port, event_time, event_content) \
VALUES(NEW.host_name, NEW.metric_arg, SUBSTRING_INDEX(NEW.metric_val,':',1),\
RIGHT(NEW.metric_val, length(NEW.metric_val)-length(SUBSTRING_INDEX(NEW.metric_val,':',1))-1));
END IF;
END:

--t_host_info的mysql信息同步到t_mysql_error_log_info,t_mysql_locked_processlist,t_mysql_innodb_deadlock_event
DROP TRIGGER IF EXISTS tr_host_to_mysql_mod:
CREATE TRIGGER tr_host_to_mysql_mod AFTER UPDATE ON t_host_info 
FOR EACH ROW
BEGIN
IF(NEW.metric_name='last_log_error') THEN
INSERT IGNORE INTO t_mysql_error_log_info(mysql_host, mysql_port, line_num, error_time, error_content)\
VALUES(NEW.host_name, NEW.metric_arg, SUBSTRING_INDEX(NEW.metric_val,':',1), \
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val,':',2),':',-1),\
RIGHT(NEW.metric_val, length(NEW.metric_val)-length(SUBSTRING_INDEX(NEW.metric_val,':',2)) - 1))\
ON DUPLICATE KEY UPDATE error_content=RIGHT(NEW.metric_val, length(NEW.metric_val)-length(SUBSTRING_INDEX(NEW.metric_val,':',2)) - 1);
END IF;
IF(NEW.metric_name='last_locked_processlist') THEN
INSERT IGNORE INTO t_mysql_locked_processlist(add_time,mysql_host,mysql_port,process_id,process_user,process_host,process_time,process_info) \
VALUES(UNIX_TIMESTAMP(NOW()),NEW.host_name, NEW.metric_arg,\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-5),';',1),\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-4),';',1),\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-3),';',1),\
SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val ,';',-2),';',1),\
SUBSTRING_INDEX(NEW.metric_val ,';',-1)) ON DUPLICATE KEY UPDATE process_time=SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.metric_val,';',-2),';',1);
END IF;
IF(NEW.metric_name='innodb_deadlock_event') THEN
INSERT IGNORE INTO t_mysql_innodb_deadlock_event(mysql_host, mysql_port, event_time, event_content) \
VALUES(NEW.host_name, NEW.metric_arg, SUBSTRING_INDEX(NEW.metric_val,':',1),\
RIGHT(NEW.metric_val, length(NEW.metric_val)-length(SUBSTRING_INDEX(NEW.metric_val,':',1))-1))
ON DUPLICATE KEY UPDATE event_content=RIGHT(NEW.metric_val, length(NEW.metric_val)-length(SUBSTRING_INDEX(NEW.metric_val,':',1))-1);
END IF;
END:

delimiter ;

