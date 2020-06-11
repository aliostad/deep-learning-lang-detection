-- auto insert timeclock
DROP TRIGGER IF EXISTS `after_insert_timein`;

DELIMITER $$
CREATE TRIGGER `after_insert_timein` AFTER INSERT ON employee_time_log
FOR EACH ROW BEGIN
    INSERT INTO timeclock (keylog, log_type, clockin) 
        SELECT * FROM 
            (SELECT 
                (SELECT keylog from employee_time_log WHERE employee_id = NEW.employee_id and log_date = NEW.log_date) as keylogid, 'timeclock', CURTIME()
            ) AS tmp 
        WHERE 
            NOT EXISTS (SELECT keylog FROM timeclock WHERE keylog = keylogid and log_type = 'timeclock' and update_date = '0000-00-00 00:00:00') 
        LIMIT 1;

    -- replicate the following time log in other servers
    INSERT INTO tmp_emp_time_log (employee_id, log_date, keylog) VALUES (NEW.employee_id, NEW.log_date, NEW.keylog);

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS `after_tmp_insert_log`;

DELIMITER $$
CREATE TRIGGER `after_tmp_insert_log` AFTER INSERT ON timeclock
FOR EACH ROW BEGIN    
    IF (NEW.log_type = 'ob') THEN 
        INSERT INTO tmp_ob_log_insert (keylog, log_type, clockin) VALUES (NEW.keylog, NEW.log_type, NEW.clockin);
    END IF;
    
    IF (NEW.log_type = 'break') THEN 
        INSERT INTO tmp_break_log_insert (keylog, log_type, clockin) VALUES (NEW.keylog, NEW.log_type, NEW.clockin);
    END IF;
END $$
DELIMITER ;


DROP TRIGGER IF EXISTS `after_tmp_update_log`;

DELIMITER $$
CREATE TRIGGER `after_tmp_update_log` AFTER UPDATE ON timeclock
FOR EACH ROW BEGIN
        IF (OLD.log_type = 'ob' AND NEW.update_date <> OLD.update_date ) THEN 
        INSERT INTO tmp_ob_log_update (keylog, log_type, clockin, clockout, update_date) 
            VALUES (OLD.keylog, OLD.log_type, OLD.clockin, NEW.clockout, NEW.update_date);
    END IF;
    
    IF (NEW.log_type = 'break') THEN 
        INSERT INTO tmp_break_log_update (keylog, log_type, clockin, clockout, update_date) 
            VALUES (OLD.keylog, OLD.log_type, OLD.clockin, NEW.clockout, NEW.update_date);
    END IF;
END $$
DELIMITER ;