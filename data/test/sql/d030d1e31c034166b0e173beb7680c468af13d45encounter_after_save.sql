DELIMITER $$

DROP TRIGGER IF EXISTS `encounter_after_save`$$
CREATE trigger `encounter_after_save` AFTER INSERT ON encounter

	FOR EACH ROW BEGIN

	SET @encounter_type = ( SELECT encounter_type FROM encounter
													 WHERE patient_id = new.patient_id
													 AND encounter_id = new.encounter_id
													 AND voided = 0 AND encounter_type IN (6, 7, 9, 25, 51, 52, 53, 54, 68, 119));

    IF NOT ISNULL(@encounter_type ) THEN
		 CALL `proc_insert_basics`(
			 new.patient_id,
			 new.date_created,
			 new.creator
		 );
	 END IF;
	END$$

DELIMITER ;
