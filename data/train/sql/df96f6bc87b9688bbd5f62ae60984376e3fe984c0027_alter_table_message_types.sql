/*!40101 SET CHARACTER_SET_CLIENT='utf8' */;
/*!40101 SET NAMES utf8 */;

ALTER TABLE `message_types`
	CHANGE COLUMN `variables` `variables` VARCHAR(400) NULL DEFAULT NULL;
UPDATE `message_types` 
	SET `variables`='%%client_name%%, %%registration_date%%' 
	WHERE  `name`='new_client' LIMIT 1;
UPDATE `message_types` 
	SET `variables`='%%new_level_name%%, %%old_level_name%%, %%new_percent%%,  %%old_percent%%, %%sum_earned%%' 
	WHERE  `name`='new_level' LIMIT 1;
UPDATE `message_types` 
	SET `variables`='%%client_name%%, %%payment_sum%%, %%balance%%' 
	WHERE  `name`='new_payment' LIMIT 1;
UPDATE `message_types` 
	SET `variables`='%%ticket_id%%, %%message_text%%, %%message_date%%, %%topic%%' 
	WHERE  `name`='new_ticket' LIMIT 1;
INSERT INTO `message_types` (`name`, `title`, `template`, `variables`) 
	VALUES ('new_payout_individual', 'Состоялась выплата физ. лицу', 'new_payout_individual.html', '%%payout_sum%%, %%new_balance%%, %%contact%%, %%purse_number%%');
INSERT INTO `message_types` (`name`, `title`, `template`, `variables`) 
	VALUES ('new_payout_legal', 'Состоялась выплата юр. лицу', 'new_payout_legal.html', '%%payout_sum%%, %%new_balance%%, %%contact%%, %%company_name%%');
DELETE FROM `message_types` 
	WHERE  `name`='new_payout' LIMIT 1;
UPDATE `message_types` 
	SET `title`='Новое тикет сообщение' 
	WHERE  `name`='new_ticket' LIMIT 1;
