ALTER TABLE  `contacts` ADD UNIQUE ( `phone`, `contact_group_id` );

-- ALTER TABLE  `contacts` ADD INDEX (  `created_at` );


--
-- Triggers `callees`
--
DROP TRIGGER IF EXISTS `movetocouch`;
DELIMITER //
CREATE TRIGGER `movetocouch` AFTER INSERT ON `contacts`
 FOR EACH ROW BEGIN
    INSERT IGNORE INTO contacts_couch_insert SET id=NEW.id, phone=NEW.phone,name=NEW.name,email=NEW.email,contact_group_id=NEW.contact_group_id,created_at=NEW.created_at,updated_at=NEW.updated_at,`couchrest-type`="Calleecouch";
  END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `updateincouch`;
DELIMITER //
CREATE TRIGGER `updateincouch` BEFORE UPDATE ON `contacts`
 FOR EACH ROW BEGIN
    INSERT INTO contacts_couch_update SET id=NEW.id, phone=NEW.phone,name=NEW.name,email=NEW.email,contact_group_id=NEW.contact_group_id,created_at=NEW.created_at,updated_at=NEW.updated_at,`couchrest-type`="Calleecouch" ON DUPLICATE KEY UPDATE name = values(name), phone = values(phone), email = values(email);
  END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `deleteincouch`;
DELIMITER //
CREATE TRIGGER `deleteincouch` BEFORE DELETE ON `contacts`
 FOR EACH ROW BEGIN
    INSERT INTO contacts_couch_delete SET id=OLD.id;
  END
//
DELIMITER ;
