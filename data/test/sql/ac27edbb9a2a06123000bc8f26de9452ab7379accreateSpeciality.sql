-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE `createSpeciality`(OUT newSpecialityId INT, IN pName VARCHAR(50))
mainJob:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET newSpecialityId = NULL;
		ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		SET newSpecialityId = NULL;
		ROLLBACK;
	END;

	START TRANSACTION;
		SELECT id INTO newSpecialityId FROM speciality ORDER BY id DESC LIMIT 1;
		
		IF newSpecialityId IS NULL THEN
			SET newSpecialityId = 1;
		ELSE
			SET newSpecialityId = newSpecialityId + 1;
		END IF;

		INSERT INTO `speciality` (`id`, `name`) VALUES (newSpecialityId, pName);
	COMMIT;
END