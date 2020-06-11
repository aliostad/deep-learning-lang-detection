DELIMITER $$

CREATE TRIGGER trackInsertHistory
AFTER INSERT ON events
FOR EACH ROW BEGIN
    INSERT INTO events_history
    VALUES (NEW.title, NEW.start, NEW.end, NEW.resourceID, NEW.category_id, 1, NOW());
END$$

CREATE TRIGGER trackUpdateHistory
AFTER UPDATE ON events
FOR EACH ROW BEGIN
    INSERT INTO events_history
    VALUES (NEW.title, NEW.start, NEW.end, NEW.resourceID, NEW.category_id, 2, NOW());
END$$

CREATE TRIGGER trackDeleteHistory
AFTER DELETE ON events
FOR EACH ROW BEGIN
    INSERT INTO events_history
    VALUES (OLD.title, OLD.start, OLD.end, OLD.resourceID, OLD.category_id, 3, NOW());
END$$
DELIMITER ;