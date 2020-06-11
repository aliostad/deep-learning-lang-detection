DELIMITER $$

	DROP TRIGGER IF EXISTS `cohort_for_table1`$$

	CREATE TRIGGER `cohort_for_table1` AFTER UPDATE ON flat_table1

	FOR EACH ROW BEGIN

    SET @eligible = (SELECT earliest_start_date FROM flat_table1 WHERE patient_id = new.patient_id);

    IF @eligible IS NOT NULL THEN
      SET @age_at_initiation = (SELECT age_at_initiation FROM earliest_start_date WHERE patient_id = new.patient_id);
    	SET @record_exists = (SELECT id FROM flat_cohort_table WHERE patient_id = new.patient_id);

    		IF @record_exists IS NULL THEN

					INSERT INTO flat_cohort_table ( patient_id, gender, birthdate, earliest_start_date, date_enrolled, age_at_initiation, age_in_days, death_date, reason_for_starting, ever_registered_at_art, date_art_last_taken, taken_art_in_last_two_months, extrapulmonary_tuberculosis, pulmonary_tuberculosis, pulmonary_tuberculosis_last_2_years, kaposis_sarcoma,extrapulmonary_tuberculosis_v_date, pulmonary_tuberculosis_v_date, pulmonary_tuberculosis_last_2_years_v_date, kaposis_sarcoma_v_date, reason_for_starting_v_date, ever_registered_at_art_v_date, date_art_last_taken_v_date, taken_art_in_last_two_months_v_date) VALUES (new.patient_id, new.gender, new.dob, @eligible, @age_at_initiation, @age_in_days, new.death_date, new.reason_for_eligibility, new.ever_registered_at_art_clinic, new.date_art_last_taken, new.taken_art_in_last_two_months, new.extrapulmonary_tuberculosis, new.pulmonary_tuberculosis, new.pulmonary_tuberculosis_last_2_years, new.kaposis_sarcoma,new.extrapulmonary_tuberculosis_v_date, new.pulmonary_tuberculosis_v_date, new.pulmonary_tuberculosis_last_2_years_v_date, new.kaposis_sarcoma_v_date, new.reason_for_starting_v_date, new.ever_registered_at_art_v_date, new.date_art_last_taken_v_date, new.taken_art_in_last_two_months_v_date);

				ELSE

					UPDATE flat_cohort_table SET earliest_start_date = new.earliest_start_date, date_enrolled = new.date_enrolled, gender =	new.gender, birthdate = new.dob, age_at_initiation = new.age_at_initiation, age_in_days = new.age_in_days WHERE patient_id = new.patient_id;

					CALL proc_update_cohort_flat_table(
						new.patient_id,
						new.reason_for_eligibility,
						new.ever_registered_at_art_clinic,
						new.date_art_last_taken,
						new.taken_art_in_last_two_months,
						new.extrapulmonary_tuberculosis,
						new.pulmonary_tuberculosis,
						new.pulmonary_tuberculosis_last_2_years,
						new.kaposis_sarcoma,
						new.extrapulmonary_tuberculosis_v_date,
						new.pulmonary_tuberculosis_v_date,
						new.pulmonary_tuberculosis_last_2_years_v_date,
						new.kaposis_sarcoma_v_date,
						new.reason_for_starting_v_date,
						new.ever_registered_at_art_v_date,
						new.date_art_last_taken_v_date,
						new.taken_art_in_last_two_months_v_date );

				END IF;

		END IF;
	END$$

DELIMITER ;
