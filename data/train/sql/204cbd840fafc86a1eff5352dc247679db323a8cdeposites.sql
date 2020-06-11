DROP TRIGGER IF EXISTS `autoDeposits`;
DELIMITER //
CREATE TRIGGER `autoDeposits` AFTER INSERT ON `payments_master`
 FOR EACH ROW BEGIN

  IF NEW.`PM_Operator` = 'WEB' THEN

INSERT INTO `esoftcar_centralserver`.`deposits`(`branch`, `section`, `amount`, `type`, `account`, `getCollectionDate`, `getDepositDate`, `getDateNow`, `getOperator`, `getComment`) VALUES (LEFT(NEW.`PM_Receipt_No`, 3), LEFT(NEW.`PM_Receipt_No`, 5), NEW.`PM_Amount`, NEW.`PM_Type`, '17', NEW.`PM_Date`, NOW(), NOW(), 'WEB','' ) ON DUPLICATE KEY UPDATE `amount`= (`amount` + NEW.`PM_Amount`);

  END IF;
  

END
//
DELIMITER ;
