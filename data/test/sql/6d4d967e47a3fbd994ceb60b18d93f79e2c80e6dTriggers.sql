DROP TRIGGER IF EXISTS `phpbb_to_mantis_insert`;
DELIMITER //
CREATE TRIGGER `phpbb_to_mantis_insert` BEFORE INSERT ON `phpbb_users`
 FOR EACH ROW BEGIN
 
	IF NOT NEW.user_type = 3 THEN

		INSERT INTO mantis_user_table (username, realname, email, password, enabled, protected, access_level, login_count, lost_password_request_count, failed_login_count, cookie_string, last_visit, date_created) VALUES (NEW.username, NEW.username, NEW.user_email, NEW.user_password, 1, 0, 25, 1, 0, 0, LEFT(UUID(), 64), UNIX_TIMESTAMP(), UNIX_TIMESTAMP())
		ON DUPLICATE KEY UPDATE email=NEW.user_email, password=NEW.user_password, cookie_string=LEFT(UUID(), 64);

	END IF;
	
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `phpbb_to_mantis_update`;
DELIMITER //
CREATE TRIGGER `phpbb_to_mantis_update` BEFORE UPDATE ON `phpbb_users`
 FOR EACH ROW BEGIN
 
	IF NOT NEW.user_type = 3 THEN

		INSERT INTO mantis_user_table (username, realname, email, password, enabled, protected, access_level, login_count, lost_password_request_count, failed_login_count, cookie_string, last_visit, date_created) VALUES (NEW.username, NEW.username, NEW.user_email, NEW.user_password, 1, 0, 25, 1, 0, 0, LEFT(UUID(), 64), UNIX_TIMESTAMP(), UNIX_TIMESTAMP())
		ON DUPLICATE KEY UPDATE email=NEW.user_email, password=NEW.user_password, cookie_string=LEFT(UUID(), 64);

	END IF;
	
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `phpbb_to_mantis_delete`;
DELIMITER //
CREATE TRIGGER `phpbb_to_mantis_delete` BEFORE DELETE ON `phpbb_users`
FOR EACH ROW DELETE FROM mantis_user_table WHERE username=OLD.username
//
DELIMITER ;