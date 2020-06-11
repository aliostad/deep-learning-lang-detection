DELIMITER $$

DROP TRIGGER IF EXISTS `person_name_after_update`$$
CREATE trigger `person_name_after_update` AFTER UPDATE ON person_name

	FOR EACH ROW BEGIN
	
		IF new.voided = 1 THEN
		
			UPDATE flat_table1 SET given_name = NULL,middle_name = NULL ,family_name = NULL, date_created = NULL, dob = NULL, dob_estimated = NULL, gender = NULL  where patient_id = new.person_id and given_name = new.given_name;	
		
		ELSE
		
			UPDATE flat_table1 SET given_name = new.given_name, middle_name = new.middle_name, family_name = new.family_name where patient_id = new.person_id;	
		
		SET @id = (SELECT id from flat_table1 WHERE patient_id = new.person_id);
		
		CALL `proc_insert_basics`(
			new.person_id,
			@id
		); 

		
		END IF;
	END$$

DELIMITER ;

