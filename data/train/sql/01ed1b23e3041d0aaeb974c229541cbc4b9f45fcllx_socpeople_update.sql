USE `prestashop`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `llx_socpeople_AINS` AFTER INSERT ON `llx_socpeople` FOR 
EACH ROW
BEGIN
	IF(NEW.id_sin = 0) THEN
		INSERT INTO `tms_log_direccion`(
			`id_row`,
			`id_sin`,
			`id_cliente`,
			`firstname`,
			`lastname`,
			`address`,
			`postcode`,
			`city`,
			`phone`,
			`phone_mobile`,
			`date_add`,
			`alias`,
			`active`,
			`system`,
			`action`,
			`id_estado`
		)VALUES(
			NEW.rowid,
			NEW.id_sin,
			NEW.fk_soc,
			NEW.firstname, 
			NEW.lastname, 
			NEW.address, 
			NEW.zip, 
			NEW.town, 
			NEW.phone, 
			NEW.phone_mobile, 
			NEW.datec, 
			NEW.poste, 
			NEW.statut,
			'dolibar',
			'insert',
			0
		);
	END IF;
END