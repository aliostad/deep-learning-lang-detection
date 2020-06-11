DELIMITER $$

DROP TRIGGER IF EXISTS `person_name_hotline_after_update`$$
CREATE trigger `person_name_hotline_after_update` AFTER UPDATE ON person_name

	FOR EACH ROW BEGIN
		SET @id = (SELECT id from patient_demographics WHERE patient_id = new.person_id);

		IF ISNULL(@id) THEN
			SET @select = @id;
		ELSE
			IF new.voided = 1 THEN

				UPDATE patient_demographics
				SET given_name = NULL, mothers_surname = NULL, last_name = NULL,  nick_name = NULL, date_created = NULL, date_of_birth = NULL, birthdate_est = NULL, gender = NULL
				WHERE id = @id;

			ELSE

				UPDATE patient_demographics
				SET given_name = new.given_name, mothers_surname = new.family_name2, last_name = new.family_name, nick_name = new.family_name_prefix
				WHERE id = @id;

				SET @id = (SELECT id from patient_demographics WHERE patient_id = new.person_id);

				CALL `proc_insert_hotline_basics`(
					new.person_id,
					new.date_created,
					@id

				);
			END IF;
		END IF;

	END$$

DELIMITER ;
