DROP TABLE IF EXISTS `commh_log`;
DROP TRIGGER  ai_commh;
DROP TRIGGER  au_commh;
DROP TRIGGER  ad_commh;

CREATE TABLE `commh_log` (
  `id`     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ts`     datetime,
  `action` ENUM('create','update old','update new', 'delete'),
  `commh_id` int(11) NOT NULL,
  `comm_type` int(1) NOT NULL COMMENT '0 creacion, 1 abono, 2 Renovacion, 3 mensual, 4 reversa, 5 NR',
  `inv_id` int(11) NOT NULL,
  `inv_num` int(11) NOT NULL,
  `inv_name` varchar(100) NOT NULL,
  `investor_id` varchar(20) NOT NULL,
  `operation_date` date NOT NULL,
  `comm_date` date NOT NULL,
  `inv_length` int(2) NOT NULL,
  `inv_exp_period` int(2) NOT NULL,
  `inv_amount` bigint(20) NOT NULL,
  `exec_comm` bigint(20) NOT NULL,
  `dc1_comm` bigint(20) DEFAULT NULL,
  `dc2_comm` bigint(20) DEFAULT NULL,
  `dc3_comm` bigint(20) DEFAULT NULL,
  `dc4_comm` bigint(20) DEFAULT NULL,
  `dc5_comm` bigint(20) DEFAULT NULL,
  `exec_initials` varchar(5) NOT NULL,
  `dc1_initials` varchar(5) DEFAULT NULL,
  `dc2_initials` varchar(5) DEFAULT NULL,
  `dc3_initials` varchar(5) DEFAULT NULL,
  `dc4_initials` varchar(5) DEFAULT NULL,
  `dc5_initials` varchar(5) DEFAULT NULL,
  `exec_id` int(11) NOT NULL,
  `dc1_id` int(11) DEFAULT NULL,
  `dc2_id` int(11) DEFAULT NULL,
  `dc3_id` int(11) DEFAULT NULL,
  `dc4_id` int(11) DEFAULT NULL,
  `dc5_id` int(11) DEFAULT NULL,
  `exec_value` decimal(4,2) NOT NULL,
  `dc1_value` decimal(4,2) DEFAULT NULL,
  `dc2_value` decimal(4,2) DEFAULT NULL,
  `dc3_value` decimal(4,2) DEFAULT NULL,
  `dc4_value` decimal(4,2) DEFAULT NULL,
  `dc5_value` decimal(4,2) DEFAULT NULL,
  `csch_start_date` date NOT NULL,
  `csch_id` int(11) NOT NULL,
  `state` int(1) NOT NULL DEFAULT '0' COMMENT '0 ok, 1 nok, 2 no pagada, 3 calcular',
  `paid_exec` bigint(20) DEFAULT NULL,
  `paid_dc1` bigint(20) DEFAULT NULL,
  `paid_dc2` bigint(20) DEFAULT NULL,
  `paid_dc3` bigint(20) DEFAULT NULL,
  `comments` varchar(200) DEFAULT NULL,
  `creation_date` datetime NOT NULL,
  `creation_user` varchar(20) NOT NULL,
  `lastmod_date` datetime DEFAULT NULL,
  `lastmod_user` varchar(20) DEFAULT NULL,
  `modified` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;



delimiter //

CREATE TRIGGER ai_commh AFTER INSERT ON commission_history
FOR EACH ROW

BEGIN

  INSERT INTO commh_log (action,ts,commh_id, comm_type, inv_id, inv_num, inv_name, investor_id, operation_date, comm_date, inv_length, inv_exp_period,inv_amount, exec_comm, 
		dc1_comm, dc2_comm, dc3_comm, dc4_comm, dc5_comm, exec_initials, dc1_initials, dc2_initials, dc3_initials, dc4_initials, dc5_initials, 
		exec_id, dc1_id, dc2_id, dc3_id, dc4_id, dc5_id, exec_value, dc1_value, dc2_value, dc3_value, dc4_value, dc5_value, csch_start_date, csch_id , comments, creation_date, creation_user,
		lastmod_date, lastmod_user, modified)
  VALUES('create',NOW(), NEW.id, NEW.comm_type, NEW.inv_id, NEW.inv_num, NEW.inv_name, NEW.investor_id, NEW.operation_date, NEW.comm_date, NEW.inv_length, NEW.inv_exp_period, NEW.inv_amount, NEW.exec_comm, 
  	NEW.dc1_comm, NEW.dc2_comm, NEW.dc3_comm, NEW.dc4_comm, NEW.dc5_comm, NEW.exec_initials, NEW.dc1_initials, NEW.dc2_initials, NEW.dc3_initials, NEW.dc4_initials, NEW.dc5_initials, 
  	NEW.exec_id, NEW.dc1_id, NEW.dc2_id, NEW.dc3_id, NEW.dc4_id, NEW.dc5_id, NEW.exec_value, NEW.dc1_value, NEW.dc2_value, NEW.dc3_value, NEW.dc4_value, NEW.dc5_value, NEW.csch_start_date, NEW.csch_id , 
	NEW.comments, NEW.creation_date, NEW.creation_user, NEW.lastmod_date, NEW.lastmod_user, NEW.modified);

END;
//

delimiter //

CREATE TRIGGER au_commh AFTER UPDATE ON commission_history

FOR EACH ROW

BEGIN

  
  INSERT INTO commh_log (action,ts,commh_id, comm_type, inv_id, inv_num, inv_name, investor_id, operation_date, comm_date, inv_length, inv_exp_period,inv_amount, exec_comm, 
		dc1_comm, dc2_comm, dc3_comm, dc4_comm, dc5_comm, exec_initials, dc1_initials, dc2_initials, dc3_initials, dc4_initials, dc5_initials, 
		exec_id, dc1_id, dc2_id, dc3_id, dc4_id, dc5_id, exec_value, dc1_value, dc2_value, dc3_value, dc4_value, dc5_value, csch_start_date, csch_id , comments, creation_date, creation_user,
		lastmod_date, lastmod_user, modified)
  VALUES
  
  ('update old',NOW(), OLD.id, OLD.comm_type, OLD.inv_id, OLD.inv_num, OLD.inv_name, OLD.investor_id, OLD.operation_date, OLD.comm_date, OLD.inv_length, OLD.inv_exp_period, OLD.inv_amount, OLD.exec_comm, 
  OLD.dc1_comm, OLD.dc2_comm, OLD.dc3_comm, OLD.dc4_comm, OLD.dc5_comm, OLD.exec_initials, OLD.dc1_initials, OLD.dc2_initials, OLD.dc3_initials, OLD.dc4_initials, OLD.dc5_initials, 
  OLD.exec_id, OLD.dc1_id, OLD.dc2_id, OLD.dc3_id, OLD.dc4_id, OLD.dc5_id, OLD.exec_value, OLD.dc1_value, OLD.dc2_value, OLD.dc3_value, OLD.dc4_value, OLD.dc5_value, OLD.csch_start_date, OLD.csch_id , 
  OLD.comments, OLD.creation_date, OLD.creation_user, OLD.lastmod_date, OLD.lastmod_user, OLD.modified),
  ('update new',NOW(), NEW.id, NEW.comm_type, NEW.inv_id, NEW.inv_num, NEW.inv_name, NEW.investor_id, NEW.operation_date, NEW.comm_date, NEW.inv_length, NEW.inv_exp_period, NEW.inv_amount, NEW.exec_comm, 
  NEW.dc1_comm, NEW.dc2_comm, NEW.dc3_comm, NEW.dc4_comm, NEW.dc5_comm, NEW.exec_initials, NEW.dc1_initials, NEW.dc2_initials, NEW.dc3_initials, NEW.dc4_initials, NEW.dc5_initials, 
  NEW.exec_id, NEW.dc1_id, NEW.dc2_id, NEW.dc3_id, NEW.dc4_id, NEW.dc5_id, NEW.exec_value, NEW.dc1_value, NEW.dc2_value, NEW.dc3_value, NEW.dc4_value, NEW.dc5_value, NEW.csch_start_date, NEW.csch_id , 
  NEW.comments, NEW.creation_date, NEW.creation_user, NEW.lastmod_date, NEW.lastmod_user, NEW.modified);

END;
//


delimiter //

CREATE TRIGGER ad_commh AFTER DELETE ON commission_history

FOR EACH ROW

BEGIN

  INSERT INTO commh_log (action,ts,commh_id, comm_type, inv_id, inv_num, inv_name, investor_id, operation_date, comm_date, inv_length, inv_exp_period,inv_amount, exec_comm, 
		dc1_comm, dc2_comm, dc3_comm, dc4_comm, dc5_comm, exec_initials, dc1_initials, dc2_initials, dc3_initials, dc4_initials, dc5_initials, 
		exec_id, dc1_id, dc2_id, dc3_id, dc4_id, dc5_id, exec_value, dc1_value, dc2_value, dc3_value, dc4_value, dc5_value, csch_start_date, csch_id , comments, creation_date, creation_user,
		lastmod_date, lastmod_user, modified)
  VALUES
  
  ('delete',NOW(), OLD.id, OLD.comm_type, OLD.inv_id, OLD.inv_num, OLD.inv_name, OLD.investor_id, OLD.operation_date, OLD.comm_date, OLD.inv_length, OLD.inv_exp_period, OLD.inv_amount, OLD.exec_comm, 
  OLD.dc1_comm, OLD.dc2_comm, OLD.dc3_comm, OLD.dc4_comm, OLD.dc5_comm, OLD.exec_initials, OLD.dc1_initials, OLD.dc2_initials, OLD.dc3_initials, OLD.dc4_initials, OLD.dc5_initials, 
  OLD.exec_id, OLD.dc1_id, OLD.dc2_id, OLD.dc3_id, OLD.dc4_id, OLD.dc5_id, OLD.exec_value, OLD.dc1_value, OLD.dc2_value, OLD.dc3_value, OLD.dc4_value, OLD.dc5_value, OLD.csch_start_date, OLD.csch_id , 
  OLD.comments, OLD.creation_date, OLD.creation_user, OLD.lastmod_date, OLD.lastmod_user, OLD.modified);
END;//
