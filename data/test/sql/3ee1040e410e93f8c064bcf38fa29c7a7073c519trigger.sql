USE `user1`;  
  
DELIMITER $$  
CREATE TRIGGER `BackupReports` BEFORE UPDATE ON `reports`   
FOR EACH ROW 
BEGIN  
    INSERT INTO `reports_backup` SET
	`owner_id` = OLD.`owner_id`,
	`recipient_id` = OLD.`recipient_id`,
	`title` = OLD.`title`,
	`formatted_text` = OLD.`formatted_text`,
	`checked` = OLD.`checked`,
	`done` = OLD.`done`,
	`type_id` = OLD.`type_id`,
	`created_at` = OLD.`created_at`,
	`updated_at` = OLD.`updated_at`,
	`due_date` = OLD.`due_date`,
	`department_id` = OLD.`department_id`;
END$$  
DELIMITER ; 

