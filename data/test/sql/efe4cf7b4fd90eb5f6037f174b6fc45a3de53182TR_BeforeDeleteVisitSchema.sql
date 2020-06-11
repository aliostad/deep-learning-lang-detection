USE ece356;

DELIMITER //
CREATE TRIGGER BeforeDeleteVisitSchema
	BEFORE DELETE ON visit_schema FOR EACH ROW
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
			OLD.patient_id,
            OLD.cpso_number,
            OLD.start_time,
            OLD.end_time,
            OLD.surgery_name,
            OLD.diagnosis,
            OLD.prescription,
            OLD.comments,
            NOW(),
            'DELETE'
		);
	END
    
    