DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_READ_GetMsg$$
CREATE PROCEDURE `CLI_READ_GetMsg`(
				 		resquester_id		BIGINT UNSIGNED
				)
BEGIN
	
	-- Retrieve msg for the user according to his links and language
	SELECT 
		fm.message AS msgParam,
		fm.life_point AS paramForwardScore,
		fm.id AS msgId,
		DATEDIFF(NOW(), fm.creation_date) AS yearsOld
		FROM for_message fm JOIN for_user fu
				ON fm.language = fu.language
				WHERE fu.id = resquester_id
				ORDER BY RAND() LIMIT 20;
END$$
-- CALL CLI_READ_GetMsg (10);
