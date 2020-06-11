
DROP TRIGGER  ai_commh;
DROP TRIGGER  au_commh;
DROP TRIGGER  ad_commh;




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
