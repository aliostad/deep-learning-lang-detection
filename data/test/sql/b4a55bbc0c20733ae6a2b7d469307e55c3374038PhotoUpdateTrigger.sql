DROP TRIGGER IF EXISTS photo_after_update;
DELIMITER $$
CREATE
	TRIGGER `photo_after_update` AFTER UPDATE
	ON `photo` 
	FOR EACH ROW BEGIN
		
		DELETE FROM photo_gisindex WHERE photo_id = NEW.id;
		IF NEW.lat OR NEW.lng THEN
			INSERT INTO photo_gisindex VALUES(NEW.lat, NEW.lng, 1, NEW.id);	
		END IF;

    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS photo_after_insert;
DELIMITER $$
CREATE
	TRIGGER `photo_after_insert` AFTER INSERT
	ON `photo` 
	FOR EACH ROW BEGIN
		IF NEW.lat OR NEW.lng THEN
			INSERT INTO photo_gisindex VALUES(NEW.lat, NEW.lng, 1, NEW.id);		
		END IF;

    END$$
DELIMITER ;

DROP TRIGGER IF EXISTS photo_after_delete;
DELIMITER $$
CREATE
	TRIGGER `photo_after_delete` AFTER DELETE
	ON `photo` 
	FOR EACH ROW BEGIN
		
		DELETE FROM photo_gisindex WHERE photo_id = old.id;		

    END$$
DELIMITER ;
