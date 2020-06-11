
CREATE TRIGGER insertTrigger AFTER INSERT ON personal_data_info 
  FOR EACH ROW 
  BEGIN
  
  	DECLARE my_id INT ;
  	SET my_id = (SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA='cv_bangalore_qa' AND TABLE_NAME='user_info') ;
    INSERT INTO user_info  SET created_by = NEW.created_by , created_date = NEW.created_date
    , updated_by = NEW.updated_by , updated_date = NEW.updated_date , date_of_birth = NEW.date_of_birth
    , date_of_joining = NEW.date_of_joining , designation = NEW.designation , father_name = NEW.father_name
    , first_name = NEW.first_name , last_name = NEW.last_name , login_id = NEW.login_id
    , middle_name = NEW.middle_name , oracle_id = NEW.oracle_id , person_type = NEW.person_type 
    , supervisor_id=NEW.supervisor_id,email_address=NEW.email_address,user_status=NEW.user_status;
 END;


CREATE TRIGGER updateTrigger AFTER UPDATE ON personal_data_info 
  FOR EACH ROW 
  BEGIN
  
  	DECLARE my_id INT ;
  	SET my_id = (SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA='cv_bangalore_qa' AND TABLE_NAME='user_info') ;
    UPDATE user_info  SET created_by = NEW.created_by , created_date = NEW.created_date
    , updated_by = NEW.updated_by , updated_date = NEW.updated_date , date_of_birth = NEW.date_of_birth
    , date_of_joining = NEW.date_of_joining , designation = NEW.designation , father_name = NEW.father_name
    , first_name = NEW.first_name , last_name = NEW.last_name 
    , middle_name = NEW.middle_name , person_type = NEW.person_type , supervisor_id=NEW.supervisor_id,email_address=NEW.email_address,user_status=NEW.user_status
    WHERE oracle_id=NEW.oracle_id ;
 END;
