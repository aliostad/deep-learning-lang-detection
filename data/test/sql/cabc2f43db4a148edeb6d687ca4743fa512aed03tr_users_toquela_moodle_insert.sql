DROP TRIGGER
IF EXISTS `tr_users_toquela_moodle_insert`;
DELIMITER $$

CREATE TRIGGER `tr_users_toquela_moodle_insert` AFTER INSERT ON db_toquela.users FOR EACH ROW
BEGIN
	INSERT INTO `db_toquela`.`mdl_user` (
		`id`,
		`cod_user`,
		`confirmed`,
		`mnethostid`,
		`username`,
		`password`,
		`firstname`,
		`lastname`,
		`email`,
		`phone1`,
		`phone2`,
		`address`,
		`city`,
		`country`,
		`lang`,
		`calendartype`,
		`timezone`,
		`timecreated`
	)
VALUES
	(
		NEW.cod_user,
		NEW.cod_user,
		'1',
		'1',
		NEW.email,
		NEW.`password`,
		NEW.`name`,
		NEW.`last_name`,
		NEW.email,
		NEW.phone,
		NEW.cellular,
		NEW.address,
		NEW.city,
		'CO',
		'es',
		'gregorian',
		'-5.0',
		UNIX_TIMESTAMP()
	);
END$$
DELIMITER ;