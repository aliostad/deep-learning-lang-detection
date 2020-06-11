DROP TRIGGER IF EXISTS `c_user_ua`//
CREATE definer=`dbadmin`@`localhost` trigger `c_user_ua` AFTER UPDATE ON `c_user`
  FOR EACH ROW

/*
$Rev: 9336 $ 
$Author: randall.stanley $ 
$Date: 2010-10-03 14:10:42 -0400 (Sun, 03 Oct 2010) $
$HeadURL: http://atlanta-web.performancematters.com:8099/svn/pminternal/Data/Redwood/Core/triggers/c_user_ua.sql $
$Id: c_user_ua.sql 9336 2010-10-03 18:10:42Z randall.stanley $ 
*/

BEGIN

    IF OLD.login != NEW.login  OR NEW.active_flag = 0 THEN
        DELETE FROM pmi_user.user_login
        WHERE   pmi_user_id = old.user_id
        AND     client_id = old.client_id;
    END IF;
    
    IF NEW.active_flag = 1 THEN
        INSERT INTO pmi_user.user_login 
        SET pmi_user_id      = NEW.user_id,
            login            = NEW.login,
            password         = NEW.password,
            email_address    = NEW.email_address,
            client_id        = NEW.client_id,
            active_flag      = NEW.active_flag,
            create_timestamp = NEW.create_timestamp,
            pmi_user_agree_timestamp = NEW.pmi_user_agree_timestamp,
            client_user_agree_timestamp = NEW.client_user_agree_timestamp
        ON DUPLICATE KEY UPDATE login         = NEW.login,
                                password      = NEW.password,
                                email_address = NEW.email_address,
                                active_flag   = NEW.active_flag,
                                pmi_user_agree_timestamp = NEW.pmi_user_agree_timestamp,
                                client_user_agree_timestamp = NEW.client_user_agree_timestamp
        ;
    END IF;
    
    IF (OLD.pmi_user_agree_timestamp     != NEW.pmi_user_agree_timestamp) OR
       (OLD.client_user_agree_timestamp  != NEW.client_user_agree_timestamp) THEN 
       
         -- user has accepted an agreement
         INSERT INTO c_user_audit 
         SET   user_id                      = NEW.user_id,
               pmi_user_agree_timestamp     = IF(NEW.pmi_user_agree_timestamp != OLD.pmi_user_agree_timestamp, NEW.pmi_user_agree_timestamp, NULL), 
               client_user_agree_timestamp  = IF(NEW.client_user_agree_timestamp != OLD.client_user_agree_timestamp, NEW.client_user_agree_timestamp, NULL),
               client_id                    = IF(NEW.client_id != OLD.client_id, NEW.client_id, OLD.client_id),
               last_user_id                 = IF(NEW.last_user_id != OLD.last_user_id, NEW.last_user_id, OLD.last_user_id),
               create_timestamp             = IF(NEW.create_timestamp != OLD.create_timestamp, NEW.create_timestamp, OLD.create_timestamp),
               last_edit_timestamp          = IF(NEW.last_edit_timestamp != OLD.last_edit_timestamp, NEW.last_edit_timestamp, OLD.last_edit_timestamp);
               
    END IF ;
    
END;
//
