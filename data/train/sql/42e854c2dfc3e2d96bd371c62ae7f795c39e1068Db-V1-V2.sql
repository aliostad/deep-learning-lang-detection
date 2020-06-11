DROP TRIGGER IF EXISTS log_primary_key;

ALTER TABLE log ADD time TIME;

DELIMITER $$
CREATE TRIGGER log_primary_key BEFORE INSERT ON log
FOR EACH ROW BEGIN
	DECLARE max_id int;
	SET NEW.date = IF( NEW.date IS NULL OR NEW.date = '0000-00-00', DATE(NOW()), NEW.date );
	SET NEW.time = IF( NEW.time IS NULL OR NEW.time = '00-00-00', TIME(NOW()), NEW.time );
	SELECT MAX(id) FROM log WHERE date = NEW.date INTO max_id;
	SET NEW.id = IF( max_id IS NULL, 1, max_id + 1);
END$$

UPDATE log SET time='00:00:00' WHERE time is NULL;

DELIMITER ;
