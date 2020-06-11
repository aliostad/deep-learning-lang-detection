DELIMITER $$
DROP TRIGGER IF EXISTS `observation_after_insert`$$
CREATE TRIGGER `observation_after_insert` AFTER INSERT
ON `obs`
FOR EACH ROW
BEGIN

   SET @visit = COALESCE((SELECT ID FROM flat_table2 WHERE patient_id = new.person_id AND DATE(visit_date) = DATE(new.obs_datetime) LIMIT 1), 0);

   SET @encounter_type = COALESCE(( SELECT encounter_type FROM encounter
                            WHERE patient_id = new.person_id
                            AND DATE(encounter_datetime) = DATE(new.obs_datetime)
                            AND encounter_id = new.encounter_id
                            AND voided = 0 AND encounter_type NOT IN (6, 7, 9, 25, 51, 52, 53, 54, 68, 119)), 0);

   IF (@encounter_type = 0 ) THEN
     CALL proc_insert_observations(
        new.person_id,
        DATE(new.obs_datetime),
        new.concept_id,
        new.value_coded,
        new.value_coded_name_id,
        new.value_text,
        new.value_numeric,
        new.value_datetime,
        new.value_modifier,
        @visit,
        new.voided,
        new.encounter_id
    );


    SET @current_hiv_program_state = (SELECT current_hiv_program_state FROM flat_table2 WHERE id = @visit LIMIT 1);

    SET @current_state = (SELECT IFNULL(current_state_for_program(new.person_id,1,new.obs_datetime), 'Unknown') AS state);

    IF ISNULL(@current_hiv_program_state) THEN
      SET @patient_program_id = ( SELECT patient_program_id FROM patient_program
                                          WHERE patient_id = new.person_id
                                          AND program_id = 1 LIMIT 1);

      SET @latest_patient_hiv_state = ( SELECT state FROM patient_state
                                        WHERE patient_program_id = @patient_program_id
                                        AND start_date <= DATE(new.obs_datetime)
                                        ORDER BY patient_state_id DESC
                                        LIMIT 1);

      SET @current_hiv_state = ( SELECT c.name FROM program_workflow_state pws
                                   LEFT OUTER JOIN concept_name c ON c.concept_id = pws.concept_id
                                 WHERE pws.program_workflow_id = 1
                                 AND pws.program_workflow_state_id = @current_state
                                 AND pws.retired = 0
                                 LIMIT 1 );

      IF NOT ISNULL(@current_hiv_state) THEN
        UPDATE flat_table2
        SET current_hiv_program_state = @current_hiv_state, current_hiv_program_start_date = DATE(new.obs_datetime)
        WHERE flat_table2.id = @visit;
      END IF;
    END IF;
   END IF;

END$$

DELIMITER ;
