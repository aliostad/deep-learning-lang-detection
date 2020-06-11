DROP TRIGGER IF EXISTS `journalsUpdateTrigger`;
DELIMITER //
CREATE TRIGGER `journalsUpdateTrigger` AFTER UPDATE ON `journals`
 FOR EACH ROW BEGIN
DECLARE voucherHeaderId INT;
set voucherHeaderId = (SELECT `voucher_headers`.`id` FROM `voucher_headers` WHERE `voucher_headers`.`referenceNum` = NEW.id AND `voucher_headers`.`voucherType` = 'JV');   
DELETE FROM `voucher_details` WHERE `voucher_details`.`voucher_header_id` = voucherHeaderId;
DELETE FROM `voucher_headers` WHERE `voucher_headers`.`id` = voucherHeaderId;
INSERT INTO `voucher_headers` (`dated`, `voucherType`, `referenceNum`, `description`, `createdOn`, `createdBy`)
 VALUES (NEW.dated, 'JV', NEW.id, NEW.description, NEW.createdOn, NEW.createdBy);
INSERT INTO `voucher_details` (`voucher_header_id`, `account_id`, `drCr`, `amount`, `description`)
  (
	SELECT `voucher_headers`.`id`, NEW.from_account, 'C', NEW.amount, NEW.description
	FROM `voucher_headers`
	WHERE `voucher_headers`.`referenceNum` = NEW.id AND `voucher_headers`.`voucherType` = 'JV'
);
INSERT INTO `voucher_details` (`voucher_header_id`, `account_id`, `drCr`, `amount`, `description`)
  (
	SELECT `voucher_headers`.`id`, NEW.to_account, 'D', NEW.amount, NEW.description
	FROM `voucher_headers`
	WHERE `voucher_headers`.`referenceNum` = NEW.id AND `voucher_headers`.`voucherType` = 'JV'
);
END
//
DELIMITER ;;
