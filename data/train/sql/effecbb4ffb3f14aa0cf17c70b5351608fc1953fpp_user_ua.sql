DROP TRIGGER IF EXISTS `pp_user_ua`//
CREATE definer=`dbadmin`@`localhost` trigger `pp_user_ua` AFTER UPDATE ON `pp_user`
  FOR EACH ROW

/*
$Rev: 6928 $ 
$Author: randall.stanley $ 
$Date: 2009-04-10 10:08:29 -0400 (Fri, 10 Apr 2009) $
$HeadURL: http://atlanta-web.performancematters.com:8099/svn/pminternal/Data/Redwood/Core/triggers/pp_user_ua.sql $
$Id: pp_user_ua.sql 6928 2009-04-10 14:08:29Z randall.stanley $ 
*/

BEGIN
    IF old.login != new.login THEN
        DELETE FROM pmi_user.pp_user_login
        WHERE  pp_user_id = old.pp_user_id;
    END IF;
    
    INSERT INTO pmi_user.pp_user_login 
        
    SET pp_user_id = new.pp_user_id,
        login = new.login,
        password = new.password,
        email_address = new.email_address,
        client_id = new.client_id,
        active_flag = new.active_flag,
        create_timestamp = new.create_timestamp
        
    ON DUPLICATE KEY UPDATE login = new.login,
                            password = new.password,
                            email_address = new.email_address,
                            active_flag = new.active_flag;
    
END;
//
