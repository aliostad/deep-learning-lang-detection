GO
DROP TABLE cmd_param
GO
CREATE TABLE IF NOT EXISTS `cmd_param` ( 
    `id`         	int(11) AUTO_INCREMENT NOT NULL,
    `cmd_id`      int(11) not null,
    `parent_id` int(11),
    `level` varchar(5) DEFAULT NULL,
    `status` varchar(1) DEFAULT '1',
    `woodenleg` varchar(50) DEFAULT NULL,
    `param_name`   varchar(50) not null,
    PRIMARY KEY(id)
) AUTO_INCREMENT=1 DEFAULT CHARSET=utf8

GO

--
DROP TRIGGER IF EXISTS `cmd_param_tg_bf_is`;
GO
CREATE TRIGGER `cmd_param_tg_bf_is` BEFORE INSERT ON `cmd_param`
 FOR EACH ROW BEGIN

DECLARE new_level INT;
DECLARE parent_woodenleg VARCHAR(100);
DECLARE new_woodenleg VARCHAR(100);
DECLARE next_id VARCHAR(100);
DECLARE c_parent CURSOR FOR SELECT woodenleg,level+1 FROM `cmd_param` WHERE id = NEW.parent_id;
SET next_id = (SELECT CAST(AUTO_INCREMENT as BINARY) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cmd_param');
IF NEW.parent_id is null THEN
SET NEW.woodenleg := SUBSTRING(CONCAT('00',next_id),LENGTH(next_id),3);
SET NEW.level := 1;
ELSE 
OPEN c_parent;
FETCH c_parent INTO parent_woodenleg,new_level;
SET new_woodenleg := CONCAT(parent_woodenleg,SUBSTRING(CONCAT('00',next_id),LENGTH(next_id),3));
SET NEW.woodenleg := new_woodenleg;
SET NEW.level := new_level;
END IF;

END
//
GO
DROP TRIGGER IF EXISTS `cmd_param_tg_bf_ud`;
GO
CREATE TRIGGER `cmd_param_tg_bf_ud` BEFORE UPDATE ON `cmd_param`
 FOR EACH ROW BEGIN

DECLARE new_level INT;
DECLARE parent_woodenleg VARCHAR(100);
DECLARE new_woodenleg VARCHAR(100);
DECLARE cur_id VARCHAR(100);
DECLARE c_parent CURSOR FOR SELECT woodenleg,level+1 FROM `cmd_param` WHERE id = NEW.parent_id;

SET cur_id = CAST(OLD.id as BINARY);

IF NEW.parent_id is null THEN
SET NEW.woodenleg := SUBSTRING(CONCAT('00',cur_id),LENGTH(cur_id),3);
SET NEW.level := 1;
ELSE 
OPEN c_parent;
FETCH c_parent INTO parent_woodenleg,new_level;
SET new_woodenleg := CONCAT(parent_woodenleg,SUBSTRING(CONCAT('00',cur_id),LENGTH(cur_id),3));
SET NEW.woodenleg := new_woodenleg;
SET NEW.level := new_level;
END IF;

END
//
GO