-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE `createService`(OUT newServiceId INT, IN pName VARCHAR(50))
mainJob:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET newServiceId = NULL;
		ROLLBACK;
	END;

	DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		SET newServiceId = NULL;
		ROLLBACK;
	END;

	START TRANSACTION;
		SELECT id INTO newServiceId FROM service ORDER BY id DESC LIMIT 1;
		
		IF newServiceId IS NULL THEN
			SET newServiceId = 1;
		ELSE
			SET newServiceId = newServiceId + 1;
		END IF;

		INSERT INTO `service` (`id`, `name`) VALUES (newServiceId, pName);
	COMMIT;
END