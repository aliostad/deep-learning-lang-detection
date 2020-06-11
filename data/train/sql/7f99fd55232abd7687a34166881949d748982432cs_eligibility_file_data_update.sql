DROP TRIGGER IF EXISTS cs_eligibility_file_data_update;
DELIMITER $$
CREATE DEFINER=`wwhsadmin`@`%` trigger cs_eligibility_file_data_update AFTER UPDATE on cs_eligibility_data
 for each row 
 BEGIN
 
 
 IF(IFNULL(old.file_id,'') <> IFNULL(new.file_id,'') AND fn_get_column_id('file_id',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('file_id',null),old.file_id,new.file_id,new.modified_by,new.modified_date);
 END IF;
 
 IF(IFNULL(old.client_id,'') <> IFNULL(new.client_id,'') AND fn_get_column_id('client_id',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('client_id',null),old.client_id,new.client_id,new.modified_by,new.modified_date);
 END IF;
 
 IF(IFNULL(old.member_first_name,'') <> IFNULL(new.member_first_name,'') AND fn_get_column_id('member_first_name',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('member_first_name',null),old.member_first_name,new.member_first_name,new.modified_by,new.modified_date);
 END IF;
 
 IF(IFNULL(old.member_last_name,'') <> IFNULL(new.member_last_name,'') AND fn_get_column_id('member_last_name',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('member_last_name',null),old.member_last_name,new.member_last_name,new.modified_by,new.modified_date);
 END IF;
 
 IF(IFNULL(old.employee_type,'') <> IFNULL(new.employee_type,'') AND fn_get_column_id('employee_type',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('employee_type',null),old.employee_type,new.employee_type,new.modified_by,new.modified_date);
 END IF;
 
 
 
 IF(IFNULL(old.date_of_birth,'') <> IFNULL(new.date_of_birth,'') AND fn_get_column_id('date_of_birth',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('date_of_birth',null),old.date_of_birth,new.date_of_birth,new.modified_by,new.modified_date);
 END IF;
 
 IF(IFNULL(old.unique_id1,'') <> IFNULL(new.unique_id1,'') AND fn_get_column_id('unique_id1',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('unique_id1',null),old.unique_id1,new.unique_id1,new.modified_by,new.modified_date);
 END IF;
 
 
 IF(IFNULL(old.unique_id2,'') <> IFNULL(new.unique_id2,'') AND fn_get_column_id('unique_id2',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('unique_id2',null),old.unique_id2,new.unique_id2,new.modified_by,new.modified_date);
 END IF;
 
 
 IF(IFNULL(old.unique_id3,'') <> IFNULL(new.unique_id3,'') AND fn_get_column_id('unique_id3',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('unique_id3',null),old.unique_id3,new.unique_id3,new.modified_by,new.modified_date);
 END IF;
 
 IF(IFNULL(old.data_source,'') <> IFNULL(new.data_source,'') AND fn_get_column_id('data_source',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('data_source',null),old.data_source,new.data_source,new.modified_by,new.modified_date);
 END IF;

 IF(IFNULL(old.active,'') <> IFNULL(new.active,'') AND fn_get_column_id('active',null) != 0) THEN
 INSERT INTO cs_eligibility_data_column_history(audit_type,file_id,data_source,cs_eligibility_data_id,column_id,oldvalue,newvalue,created_by,created_date)
 VALUES('U',new.file_id,new.data_source,old.cs_eligibility_data_id,fn_get_column_id('active',null),old.data_source,new.data_source,new.modified_by,new.modified_date);
 END IF;
 
 End