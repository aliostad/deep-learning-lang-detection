drop view F15A6_sys_admin_view;
drop view F15A6_lab_director_view;
drop view F15A6_exec_dir_view;
drop view F15A6_chairperson_view;
drop view F15A6_requester_view;

create view F15A6_sys_admin_view as
SELECT 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id
FROM F15A6_Emp where sys_admin_flag = 'Y';

create or replace TRIGGER F15A6_sys_admin_trigger
     INSTEAD OF insert ON F15A6_sys_admin_view
     FOR EACH ROW
BEGIN
    insert into F15A6_Emp( 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id)
	VALUES (:NEW.emp_id,
		:NEW.emp_name,
		:NEW.emp_email,
		:NEW.emp_office,
		:NEW.emp_phone,
		:NEW.emp_status,
		:NEW.status_eff_date,
		'Y',
		:NEW.lab_director_flag,
		:NEW.exec_director_flag,
		:NEW.chairperson_flag,
		:NEW.F15A6_Auth_auth_id,
		:NEW.F15A6_Lab_lab_id);
END;
/

create view F15A6_lab_director_view as
SELECT 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id
FROM F15A6_Emp where lab_director_flag = 'Y';

create or replace TRIGGER F15A6_lab_director_trigger
     INSTEAD OF insert ON F15A6_lab_director_view
     FOR EACH ROW
BEGIN
    insert into F15A6_Emp( 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id)
	VALUES (:NEW.emp_id,
		:NEW.emp_name,
		:NEW.emp_email,
		:NEW.emp_office,
		:NEW.emp_phone,
		:NEW.emp_status,
		:NEW.status_eff_date,
		:NEW.sys_admin_flag,
		'Y',
		:NEW.exec_director_flag,
		:NEW.chairperson_flag,
		:NEW.F15A6_Auth_auth_id,
		:NEW.F15A6_Lab_lab_id);
END;
/

create view F15A6_exec_dir_view as
SELECT 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id
FROM F15A6_Emp where exec_director_flag = 'Y' ;

create or replace TRIGGER F15A6_exec_dir_trigger
     INSTEAD OF insert ON F15A6_exec_dir_view
     FOR EACH ROW
BEGIN
    insert into F15A6_Emp( 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id)
	VALUES (:NEW.emp_id,
		:NEW.emp_name,
		:NEW.emp_email,
		:NEW.emp_office,
		:NEW.emp_phone,
		:NEW.emp_status,
		:NEW.status_eff_date,
		:NEW.sys_admin_flag,
		:NEW.lab_director_flag,
		'Y',
		:NEW.chairperson_flag,
		:NEW.F15A6_Auth_auth_id,
		:NEW.F15A6_Lab_lab_id);
END;
/

create view F15A6_chairperson_view as
SELECT 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id
FROM F15A6_Emp where chairperson_flag = 'Y' ;

create or replace TRIGGER F15A6_chairperson_trigger
     INSTEAD OF insert ON F15A6_chairperson_view
     FOR EACH ROW
BEGIN
    insert into F15A6_Emp( 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id)
	VALUES (:NEW.emp_id,
		:NEW.emp_name,
		:NEW.emp_email,
		:NEW.emp_office,
		:NEW.emp_phone,
		:NEW.emp_status,
		:NEW.status_eff_date,
		:NEW.sys_admin_flag,
		:NEW.lab_director_flag,
		:NEW.exec_director_flag,
		'Y',
		:NEW.F15A6_Auth_auth_id,
		:NEW.F15A6_Lab_lab_id);
END;
/

create view F15A6_requester_view as
SELECT 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id
FROM F15A6_Emp where sys_admin_flag = 'N' AND lab_director_flag = 'N'
	 AND exec_director_flag = 'N' AND chairperson_flag = 'N';

create or replace TRIGGER F15A6_requester_trigger
     INSTEAD OF insert ON F15A6_requester_view
     FOR EACH ROW
BEGIN
    insert into F15A6_Emp( 
	emp_id,
	emp_name,
	emp_email,
	emp_office,
	emp_phone,
	emp_status,
	status_eff_date,Syst
	sys_admin_flag,
	lab_director_flag,
	exec_director_flag,
	chairperson_flag,
	F15A6_Auth_auth_id,
	F15A6_Lab_lab_id)
	VALUES (:NEW.emp_id,
		:NEW.emp_name,
		:NEW.emp_email,
		:NEW.emp_office,
		:NEW.emp_phone,
		:NEW.emp_status,
		:NEW.status_eff_date,
		'N',
		'N',
		'N',
		'N',
		:NEW.F15A6_Auth_auth_id,
		:NEW.F15A6_Lab_lab_id);
END;
/