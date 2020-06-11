USE `prestashop`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `ps_customer_AUPD` AFTER UPDATE ON `ps_customer` FOR 
EACH ROW
BEGIN
	DECLARE accion VARCHAR(128);
	DECLARE sistema VARCHAR(128);
	DECLARE id_last INT;
	SET accion = (SELECT `action` FROM `tms_log_clientes` ORDER BY `id_log` DESC LIMIT 0, 1);
	SET sistema = (SELECT `system` FROM `tms_log_clientes` ORDER BY `id_log` DESC LIMIT 0, 1);
	SET id_last = (SELECT `id_row` FROM `tms_log_clientes` ORDER BY `id_log` DESC LIMIT 0, 1);
	
	IF (accion != 'update' OR sistema != 'dolibar' OR NEW.id_sin != id_last) THEN
		INSERT INTO `tms_log_clientes`(
			`id_row`,
			`id_sin`,
			`email`,
			`website`,
			`note`,
			`cuil`,
			`nombre`,
			`active`,
			`date_upd`,
			`system`,
			`action`,
			`id_estado`
		)VALUES(
			NEW.id_customer,
			NEW.id_sin,
			NEW.email,
			NEW.website,
			NEW.note,
			NEW.cuil,
			NEW.firstname,
			NEW.active,
			NEW.date_upd,
			'prestashop',
			'update',
			0
		);
	END IF;
END