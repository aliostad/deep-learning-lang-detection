DROP TRIGGER IF EXISTS `pp_user_ia`//
CREATE definer=`dbadmin`@`localhost` trigger `pp_user_ia` AFTER INSERT ON `pp_user`
  FOR EACH ROW

/*
$Rev: 6928 $ 
$Author: randall.stanley $ 
$Date: 2009-04-10 10:08:29 -0400 (Fri, 10 Apr 2009) $
$HeadURL: http://atlanta-web.performancematters.com:8099/svn/pminternal/Data/Redwood/Core/triggers/pp_user_ia.sql $
$Id: pp_user_ia.sql 6928 2009-04-10 14:08:29Z randall.stanley $ 
*/

BEGIN
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
