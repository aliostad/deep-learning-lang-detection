ALTER TABLE veteran ADD hash VARCHAR(255) NOT NULL DEFAULT '-';;

-- set hash value for current veterans
UPDATE veteran
SET hash = CONCAT(LOWER(last_name), '%->', ssn_last_four, '%->', IFNULL(birth_date, '{[DATE]}'), '%->', IFNULL(LOWER(middle_name), '{[MIDDLE]}'));;

/* IF THERE IS A FAILURE ON NEXT LINE: this means that there are duplicate veterans which must be removed 
 * from the database before this fix can be put into place. */ 
ALTER TABLE veteran ADD CONSTRAINT UNIQUE KEY ux_veteran_hash (hash);;

-- The following triggers make sure we are unique over these fields (even if null): last_name, ssn_last_four, birth_date, middle_name
CREATE TRIGGER veteran_hash_before_insert BEFORE INSERT ON veteran
FOR EACH ROW
BEGIN
    SET NEW.hash = CONCAT(LOWER(NEW.last_name), '%->', NEW.ssn_last_four, '%->', IFNULL(NEW.birth_date, '{[DATE]}'), '%->', IFNULL(LOWER(NEW.middle_name), '{[MIDDLE]}'));
END;;
CREATE TRIGGER veteran_hash_Before_Update BEFORE UPDATE ON veteran
FOR EACH ROW
BEGIN
    IF NEW.last_name != OLD.last_name OR NEW.ssn_last_four != OLD.ssn_last_four OR NEW.birth_date != OLD.birth_date OR NEW.middle_name != OLD.middle_name THEN 
        SET NEW.hash = CONCAT(LOWER(NEW.last_name), '%->', NEW.ssn_last_four, '%->', IFNULL(NEW.birth_date, '{[DATE]}'), '%->', IFNULL(LOWER(NEW.middle_name), '{[MIDDLE]}'));
    END IF;
END;;