DROP TRIGGER IF EXISTS `c_rti_student_interv_ua` //
CREATE definer=`dbadmin`@`localhost` trigger `c_rti_student_interv_ua` AFTER UPDATE ON `c_rti_student_interv`
  FOR EACH ROW


BEGIN

    INSERT INTO c_rti_student_interv_au 
        
    SET     intervention_item_id = NEW.intervention_item_id
            ,student_id = NEW.student_id
            ,measure_id = NEW.measure_id
            ,intervention_id = NEW.intervention_id
            ,start_date = NEW.start_date
            ,action_code = 'u'
            ,audit_user_id = NEW.last_user_id
            ,tier_code = IF(NEW.tier_code != OLD.tier_code, OLD.tier_code, NULL)
            ,area_code = IF(NEW.area_code != OLD.area_code, OLD.area_code, NULL)
            ,subject_text = IF(NEW.subject_text != OLD.subject_text, OLD.subject_text, NULL)
            ,baseline_score = IF(NEW.baseline_score != OLD.baseline_score, OLD.baseline_score, NULL)
            ,goal_score = IF(NEW.goal_score != OLD.goal_score, OLD.goal_score, NULL)
            ,goal_date = IF(NEW.goal_date != OLD.goal_date, OLD.goal_date, NULL)
            ,completion_date = IF(NEW.completion_date != OLD.completion_date, OLD.completion_date, NULL)
            ,interv_user_id = IF(NEW.interv_user_id != OLD.interv_user_id, OLD.interv_user_id, NULL)
            ,unit_of_meas = IF(NEW.unit_of_meas != OLD.unit_of_meas, OLD.unit_of_meas, NULL)
            ,frequency = IF(NEW.frequency != OLD.frequency, OLD.frequency, NULL)
            ,duration = IF(NEW.duration != OLD.duration, OLD.duration, NULL)
            ,group_size = IF(NEW.group_size != OLD.group_size, OLD.group_size, NULL)
            ,attendance = IF(NEW.attendance != OLD.attendance, OLD.attendance, NULL)
            ,delivery = IF(NEW.delivery != OLD.delivery, OLD.delivery, NULL)
            ,student_response = IF(NEW.student_response != OLD.student_response, OLD.student_response, NULL)
            ,student_status = IF(NEW.student_status != OLD.student_status, OLD.student_status, NULL)
            ,remarks = IF(NEW.remarks != OLD.remarks, OLD.remarks, NULL)
            ,school_year_id = IF(NEW.school_year_id != OLD.school_year_id, OLD.school_year_id, NULL)
            ,client_id = IF(NEW.client_id != OLD.client_id, OLD.client_id, NULL)
            ,create_user_id = NEW.create_user_id
            ,last_user_id = IF(NEW.last_user_id != OLD.last_user_id, OLD.last_user_id, NULL)
            ,create_timestamp = NEW.create_timestamp
            ,last_edit_timestamp = IF(NEW.last_edit_timestamp != OLD.last_edit_timestamp, OLD.last_edit_timestamp, NULL)
    ;

END;
//
