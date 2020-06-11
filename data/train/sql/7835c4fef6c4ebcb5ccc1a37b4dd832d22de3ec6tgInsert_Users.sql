DELIMITER $$

USE `horseracing`$$

DROP TRIGGER /*!50032 IF EXISTS */ `tgInsert_Users`$$

CREATE
    /*!50017 DEFINER = 'occbuu'@'%' */
    TRIGGER `tgInsert_Users` AFTER INSERT ON `users` 
    FOR EACH ROW BEGIN
	CALL spInsert_Logs(
	IFNULL(NEW.`ImieNo`,NEW.`id`),
	DATE_FORMAT(NEW.`ModifiedDate`,'%Y%m%d'),
	'INSERT new users',
	CONCAT( 'Password : ',IFNULL(NEW.`password`,'[null]'), '  <br/>',
		'Fullname : ',IFNULL(NEW.`fullname`,'[null]'), '  <br/>',
		'Parent ID : ',IFNULL(NEW.`pid`,'[null]'), '  <br/>',
		'Currency : ',IFNULL(NEW.`currency`,'[null]'), '  <br/>',
		'Member Fee : ',IFNULL(NEW.`fees`,'[null]'), '  <br/>'
		,'Phone number : ',IFNULL(NEW.`phonenumber`,'[null]'), '  <br/>'
		,'Status : ',IFNULL(NEW.`status`,'[null]'), '  <br/>'
		,'Remark : ',IFNULL(NEW.`remark`,'[null]'), '  <br/>'
		,'Serial number: ',IFNULL(NEW.`serialNo`,'[null]'), '  <br/>'
		,'Verify code : ',IFNULL(NEW.`verifyCode`,'[null]'), '  <br/>'
		,'Last active Date: ',IFNULL(NEW.`LastActiveDate`,'[null]')	
		),
	'1',
	NEW.`level`,
	NEW.`ModifiedBy`,
	NEW.`UserType`
	); 
    END;
$$

DELIMITER ;