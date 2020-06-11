#-------------------------------------------------------------
# Example of a rename column with deprecation support
#-------------------------------------------------------------

delimiter $$

CREATE TABLE `example` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `one` varchar(255) DEFAULT NULL,
  `two` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8$$

CREATE
DEFINER=`root`@`localhost`
TRIGGER `test`.`example_bi`
BEFORE INSERT ON `test`.`example`
FOR EACH ROW
BEGIN
 	IF (new.two is null) THEN
 		set new.two = new.one;
 	END IF;
	IF (new.one is null) THEN
		SET new.one = new.two;
	END IF;
END
$$

CREATE
DEFINER=`root`@`localhost`
TRIGGER `test`.`example_bu`
BEFORE UPDATE ON `test`.`example`
FOR EACH ROW
BEGIN
 	IF (new.one <> old.one and new.two = old.two) THEN
 		set new.two = new.one;
 	END IF;
	IF (new.two <> old.two and new.one = old.one) THEN
		SET new.one = new.two;
	END IF;
END
$$



truncate table example$$
insert into example (one) values ('value1')$$
insert into example (two) values ('value2')$$
select * from example$$

update example
	set one = '1'
where id = 1$$


update example
	set two = '2'
where id = 2$$
select * from example$$

