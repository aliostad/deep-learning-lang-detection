DROP TRIGGER IF EXISTS `c_student_ia`//
CREATE definer=`dbadmin`@`localhost` trigger `c_student_ia` AFTER INSERT ON `c_student`
  FOR EACH ROW

/*
$Rev: 7374 $ 
$Author: randall.stanley $ 
$Date: 2009-07-15 13:26:40 -0400 (Wed, 15 Jul 2009) $
$HeadURL: http://atlanta-web.performancematters.com:8099/svn/pminternal/Data/Redwood/Core/triggers/c_student_ia.sql $
$Id: c_student_ia.sql 7374 2009-07-15 17:26:40Z randall.stanley $ 
*/

BEGIN

    if new.login is not null then

        select  client_code
        into    @client_code
        from    pmi_admin.pmi_client
        where   client_id = new.client_id
        ;
        
        insert into pmi_user.ola_student_login 
            
        set client_id = new.client_id
            ,student_id = new.student_id
            ,client_code = @client_code
            ,login = new.login
            ,`password` = new.`password`
            ,active_flag = new.active_flag
            ,create_timestamp = new.create_timestamp
            
        on duplicate key update login = new.login
            ,`password` = new.`password`
            ,active_flag = new.active_flag
        ;

    end if;
    
END;

//
