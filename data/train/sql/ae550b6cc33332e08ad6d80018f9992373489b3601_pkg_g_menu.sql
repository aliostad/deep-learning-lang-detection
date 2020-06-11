 /*
  * 设置uuid
  * 
  * */
  
 DROP TRIGGER IF EXISTS tr_menu_id ;
 
 delimiter //
	create trigger tr_menu_id before insert on  G_MENU
	FOR EACH ROW if (new.ID='' or new.ID is null) then  
			       set new.ID= uuid();  
			     end if
    //
 delimiter ;
 
 -- 命令行中执行	
	DROP TRIGGER if exists tr_G_ROLE_MENU_MAP_ID;	
	delimiter //
		create trigger tr_G_ROLE_MENU_MAP_ID before insert on G_ROLE_MENU_MAP
			for each row
				 if(new.ID='' or new.ID is null) then
								set new.ID=uuid();
				 end if
		//
	delimiter ;
 