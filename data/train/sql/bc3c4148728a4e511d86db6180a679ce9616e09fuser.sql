--common
alter table user add timezone_id decimal (5,0);

alter table user add constraint foreign key 
	(timezone_id)
	references timezone_lu
	(timezone_id) 
	constraint user_timezonelu_fk;



drop trigger trig_audit_user;
drop procedure proc_user_update(varchar(50), decimal(10,0));
drop procedure proc_user_update;


create procedure proc_user_update(
new_handle varchar(50),
user_id decimal(10,0))
UPDATE user SET handle_lower = lower(new_handle), modify_date = current WHERE user.user_id = user_id;
end procedure;

create procedure proc_user_update(
user_id DECIMAL(10,0),
old_first_name VARCHAR(64),
new_first_name VARCHAR(64),
old_last_name VARCHAR(64),
new_last_name VARCHAR(64),
old_handle VARCHAR(50),
new_handle VARCHAR(50),
old_status VARCHAR(3),
new_status VARCHAR(3),
old_password VARCHAR(15),
new_password VARCHAR(15),
old_activation_code VARCHAR(32),
new_activation_code VARCHAR(32),
old_middle_name VARCHAR(64),
new_middle_name VARCHAR(64),
old_timezone_id decimal(5,0),
new_timezone_id decimal(5,0)
)
 
      if ((old_first_name != new_first_name) or (old_last_name != new_last_name ) or (old_middle_name != new_middle_name )) then
         insert into audit_user (column_name, old_value, new_value,
user_id)
         values ('NAME', NVL(old_first_name, '') || ' ' || NVL(old_middle_name, '') || ' ' || NVL(old_last_name, ''),
                 NVL(new_first_name, '') || ' ' || NVL(new_middle_name,
'') || ' ' || NVL(new_last_name, ''), user_id);
      End if;
      
      if (old_handle != new_handle) then 
         insert into audit_user (column_name, old_value, new_value,
user_id)
         values ('HANDLE', old_handle, new_handle, user_id);
      End If;

      if (old_status != new_status) then 
         insert into audit_user (column_name, old_value, new_value,
user_id)
         values ('STATUS', old_status, new_status, user_id);
      End If;

      if (old_password != new_password) then 
         insert into audit_user (column_name, old_value, new_value,
user_id)
         values ('PASSWORD', old_password, new_password, user_id);
      End If;

      if (old_activation_code != new_activation_code) then 
         insert into audit_user (column_name, old_value, new_value,
user_id)
         values ('ACTIVATION_CODE', old_activation_code, new_activation_code, user_id);
      End If;

      if (old_timezone_id != new_timezone_id) then 
         insert into audit_user (column_name, old_value, new_value,
user_id)
         values ('TIMEZONE_ID', old_timezone_id, new_timezone_id, user_id);
      End If;
      UPDATE user SET handle_lower = lower(new_handle), modify_date = current WHERE user.user_id = user_id;

end procedure;



create trigger trig_audit_user update of first_name,last_name,handle,last_login,status,password,activation_code,middle_name,timezone_id on "informix".user referencing old as old new as new    for each row
        (
        execute procedure "informix".proc_user_update(old.user_id ,old.first_name ,new.first_name ,old.last_name ,new.last_name ,old.handle ,new.handle ,old.status ,new.status ,old.password ,new.password ,old.activation_code ,new.activation_code ,old.middle_name ,new.middle_name, old.timezone_id, new.timezone_id ));


