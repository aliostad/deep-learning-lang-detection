USE `prestashop`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `llx_societe_AUPD` AFTER UPDATE ON `llx_societe` FOR 
EACH ROW
BEGIN
	DECLARE accion VARCHAR(128);
	DECLARE sistema VARCHAR(128);
	DECLARE id_last INT;

	SET accion = (SELECT `action` FROM `tms_log_clientes` ORDER BY `id_log` DESC LIMIT 0, 1);
	SET sistema = (SELECT `system` FROM `tms_log_clientes` ORDER BY `id_log` DESC LIMIT 0, 1);
	SET id_last = (SELECT `id_row` FROM `tms_log_clientes` ORDER BY `id_log` DESC LIMIT 0, 1);


		IF (accion != 'update' OR sistema != 'prestashop' OR NEW.id_sin != id_last) THEN
			INSERT INTO `tms_log_clientes`(
				`id_row`,
				`id_sin`,
				`nombre`,
				`email`,
				`website`,
				`note`,
				`cuil`,
				`address`,
				`postcode`,
				`city`,
				`phone`,
				`active`,
				`date_upd`,
				`system`,
				`action`,
				`id_estado`
			)VALUES(
				NEW.rowid,
				NEW.id_sin,
				NEW.nom,
				NEW.email,
				NEW.url,
				NEW.note_private,
				NEW.siren,
				NEW.address,
				NEW.zip,
				NEW.town,
				NEW.phone,
				NEW.status,
				NEW.datec,
				'dolibar',
				'update',
				0
			);
		END IF;
END