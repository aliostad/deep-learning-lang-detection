SELECT 
    id,
    code,
    amountXL - amountXLout AS netXL,
    netAmount,
    TimeSys,
    DateSys,
    timeSys
FROM
    ying.hs_s_MoneyFlow_rt
WHERE
    DateSys = CURRENT_DATE()
--       AND TimeSys > NOW() - INTERVAL 30 MINUTE AND 
--        code IN ('601318')
ORDER BY code , DateSys DESC , TimeSys DESC;

SELECT 
    *
FROM
    ying.hs_s_MoneyFlow_rt
WHERE
    code IN ('600030' , '601318')
ORDER BY code , DateSys DESC , TimeSys DESC;

SELECT 
    code,
    amountXL - amountXLout AS netXL,
    netAmount,
    TimeSys,
    DateSys,
    DatetimeSys
FROM
    ying.hs_s_MoneyFlow_rt
WHERE
    DateSys = CURRENT_DATE()
        AND code IN ('600030' , '601318')
ORDER BY code , id desc, DateSys DESC , TimeSys DESC;

SELECT 
    code, amountXL - amountXLout as netXL, netAmount, TimeSys, DateSys
FROM
    ying.hs_s_MoneyFlow_rt
WHERE
    code IN ('600030')
ORDER BY code, id DESC;

DELETE FROM ying.hs_s_MoneyFlow_rt 
WHERE
    DateSys = '2015-03-05' AND TimeSys < '12:59:59' AND TimeSys > '11:33:00';
    
SELECT * FROM ying.hs_s_MoneyFlow_rt 
WHERE
    DateSys = '2015-03-05' AND TimeSys < '12:59:59' AND TimeSys > '11:33:00';
    
    
USE `ying`;

DELIMITER $$

DROP TRIGGER IF EXISTS ying.hs_s_MoneyFlow_rt_BEFORE_INSERT$$
USE `ying`$$
CREATE DEFINER=`gxh`@`%` TRIGGER `ying`.`hs_s_MoneyFlow_rt_BEFORE_INSERT` BEFORE INSERT ON `hs_s_MoneyFlow_rt` FOR EACH ROW
    BEGIN   
        SET NEW.amountXL = NEW.amountXL/1000000;        
        SET NEW.amountL = NEW.amountL/1000000;        
        SET NEW.amountS = NEW.amountS/1000000;        
        SET NEW.amountI = NEW.amountI/1000000;        
        SET NEW.amountXLout = NEW.amountXLout/1000000;        
        SET NEW.amountLout = NEW.amountLout/1000000;        
        SET NEW.amountSout = NEW.amountSout/1000000;        
        SET NEW.amountIout = NEW.amountIout/1000000;        
        SET NEW.amountXLtotal = NEW.amountXLtotal/1000000;        
        SET NEW.amountLtotal = NEW.amountLtotal/1000000;        
        SET NEW.amountStotal = NEW.amountStotal/1000000;        
        SET NEW.amountItotal = NEW.amountItotal/1000000;
		SET NEW.tRatio = NEW.tRatio/100;            
        SET NEW.chgratio = NEW.chgratio*100;       
        SET NEW.volume = NEW.volume/1000000;        
        SET NEW.netAmount = NEW.netAmount/1000000;
    END$$
DELIMITER ;