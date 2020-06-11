DELIMITER $$

DROP TRIGGER IF EXISTS phpip.task_before_update$$
USE `phpip`$$
CREATE DEFINER=`root`@`%` TRIGGER `task_before_update` BEFORE UPDATE ON `task` FOR EACH ROW
BEGIN
	SET NEW.updater=SUBSTRING_INDEX(USER(),'@',1);
	IF NEW.done_date IS NOT NULL AND OLD.done_date IS NULL AND OLD.done = 0 THEN
		SET NEW.done = 1;
	END IF;
	IF NEW.done_date IS NULL AND OLD.done_date IS NOT NULL AND OLD.done = 1 THEN
		SET NEW.done = 0;
	END IF;
	IF NEW.done = 1 AND OLD.done = 0 AND OLD.done_date IS NULL THEN
		SET NEW.done_date = Least(OLD.due_date, Now());
	END IF;
	IF NEW.done = 0 AND OLD.done = 1 AND OLD.done_date IS NOT NULL THEN
		SET NEW.done_date = NULL;
	END IF;
	IF NEW.due_date != OLD.due_date AND old.rule_used IS NOT NULL THEN
		SET NEW.rule_used = NULL;
	END IF;
END$$
DELIMITER ;