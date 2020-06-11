DROP TRIGGER IF EXISTS `c_user_ia`//
CREATE definer=`dbadmin`@`localhost` trigger `c_user_ia` AFTER INSERT ON `c_user`
  FOR EACH ROW

/*
$Rev: 6928 $ 
$Author: randall.stanley $ 
$Date: 2009-04-10 10:08:29 -0400 (Fri, 10 Apr 2009) $
$HeadURL: http://atlanta-web.performancematters.com:8099/svn/pminternal/Data/Redwood/Core/triggers/c_user_ia.sql $
$Id: c_user_ia.sql 6928 2009-04-10 14:08:29Z randall.stanley $ 
*/

BEGIN

    INSERT INTO pmi_user.user_login 
        
    SET pmi_user_id = new.user_id,
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
