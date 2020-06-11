DELIMITER $$

	DROP TRIGGER IF EXISTS `person_address_hotline_after_insert` $$

	CREATE TRIGGER 	`person_address_hotline_after_insert` AFTER INSERT ON person_address

	FOR EACH ROW
	BEGIN
		IF new.voided = 1 THEN
			UPDATE patient_demographics
			SET current_residence = NULL, current_ta = NULL, home_village = NULL, group_village_head = NULL
			WHERE patient_id = new.person_id;
		ELSE
			UPDATE patient_demographics
			SET current_residence = new.neighborhood_cell, current_ta = new.county_district, home_village = new.address2, group_village_head = new.township_division
			WHERE patient_id = new.person_id;
		END IF;

	END$$

DELIMITER ;
