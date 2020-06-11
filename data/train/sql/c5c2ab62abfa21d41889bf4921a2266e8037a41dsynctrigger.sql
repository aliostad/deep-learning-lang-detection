---
-- these triggers are used for user synchronization from one wikiarguments instance to another
---

DROP TRIGGER IF EXISTS `sync_users_insert`;
DELIMITER $$
 
-- copy new users from one wikiarguments db to another
CREATE TRIGGER `sync_users_insert` AFTER INSERT ON `users` 
FOR EACH ROW 
BEGIN
    INSERT INTO $DEST.users (
        userId, 
        userName, 
        email, 
        `group`, 
        password, 
        salt, 
        dateAdded, 
        user_last_action, 
        scoreQuestions, 
        scoreArguments) 
    VALUES(
        NEW.userId, 
        NEW.userName, 
        NEW.email, 
        NEW.`group`, 
        NEW.password, 
        NEW.salt,
        NEW.dateAdded,
        0, 
        0, 
        0);
END$$
DELIMITER ;


DROP TRIGGER IF EXISTS `sync_users_update`;
DELIMITER $$
 
-- propagate user updates to another db
CREATE TRIGGER `sync_users_update` AFTER UPDATE ON `users` 
FOR EACH ROW 
BEGIN
    IF OLD.userName != NEW.userName 
    OR OLD.email != NEW.email 
    OR OLD.group != NEW.group 
    OR OLD.password != NEW.password 
    OR OLD.salt != NEW.salt THEN
        UPDATE $DEST.users 
        SET
            userName = NEW.userName, 
            email = NEW.email, 
            `group` = NEW.`group`, 
            password = NEW.password, 
            salt = NEW.salt
        WHERE userId = NEW.userId;
    END IF;
END$$
DELIMITER ;


DROP TRIGGER IF EXISTS `sync_users_delete`;
DELIMITER $$
 
-- propagate user deletes to another db
CREATE TRIGGER `sync_users_delete` AFTER DELETE ON `users` 
FOR EACH ROW 
BEGIN
    DELETE FROM $DEST.users WHERE userId = OLD.userId;
END$$
DELIMITER ;


