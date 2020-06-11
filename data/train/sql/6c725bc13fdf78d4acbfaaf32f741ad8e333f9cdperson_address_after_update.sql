DELIMITER $$

	DROP TRIGGER IF EXISTS `person_address_after_update` $$

	CREATE TRIGGER 	`person_address_after_update` AFTER UPDATE ON person_address 
	
	FOR EACH ROW	
	BEGIN
	
		IF new.voided = 1 THEN 
	
			UPDATE flat_table1 SET landmark = NULL, ta = NULL, current_address = NULL, home_district = NULL WHERE patient_id = new.person_id;
			
			
		ELSE
		
			UPDATE flat_table1 SET landmark = new.address1, ta = new.county_district, current_address = new.city_village, home_district = new.address2 WHERE patient_id = new.person_id;
		
		END IF;
	
	END$$

DELIMITER ;
