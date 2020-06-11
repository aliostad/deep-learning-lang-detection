USE ece356;

DELIMITER //
CREATE TRIGGER AfterUpdateVisitSchema
	AFTER UPDATE ON visit_schema FOR EACH ROW
    BEGIN
		INSERT INTO visit_backup_schema
		(
			patient_id,
			cpso_number,
			start_time,
			end_time,
            surgery_name,
            diagnosis,
            prescription,
			comments,
            inserted_time,
            status
		)
		VALUES
        (
			NEW.patient_id,
            NEW.cpso_number,
            NEW.start_time,
            NEW.end_time,
            NEW.surgery_name,
            NEW.diagnosis,
            NEW.prescription,
            NEW.comments,
            NOW(),
            'UPDATE'
		);
	END
    
    