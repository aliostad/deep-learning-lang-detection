
DROP TRIGGER IF EXISTS `sam_test_ua`//
CREATE definer=`dbadmin`@`localhost` trigger `sam_test_ua` AFTER UPDATE ON `sam_test`
  FOR EACH ROW

/*
$Rev: 6928 $ 
$Author: randall.stanley $ 
$Date: 2009-04-10 10:08:29 -0400 (Fri, 10 Apr 2009) $
$HeadURL: http://atlanta-web.performancematters.com:8099/svn/pminternal/Data/Redwood/Core/triggers/sam_test_ua.sql $
$Id: sam_test_ua.sql 6928 2009-04-10 14:08:29Z randall.stanley $ 
*/

BEGIN

    DELETE FROM sam_test_mt_color_sequence_list WHERE test_id = new.test_id;
    
    IF new.threshold_level > 0 and new.mastery_level > new.threshold_level THEN
    
        INSERT sam_test_mt_color_sequence_list (test_id, color_sequence, min_score, max_score, last_user_id, create_timestamp)
        VALUES ( new.test_id, 1, 0, new.threshold_level - .001, new.last_user_id, now()),
          ( new.test_id, 2, new.threshold_level, new.mastery_level - .001, new.last_user_id, now()),
          ( new.test_id, 3, new.mastery_level, 100, new.last_user_id, now());

    END IF;         
END;
//
