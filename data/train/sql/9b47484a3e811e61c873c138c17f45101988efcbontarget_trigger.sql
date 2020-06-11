DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_comment_add`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_comment_add` AFTER INSERT ON `project_task_comments` 
    FOR EACH ROW BEGIN
  INSERT INTO user_notification (TEXT, user_id, category) VALUES
    (CONCAT("Comment ", NEW.comment, " added on task ", NEW.project_task_id, " by ", NEW.comment_by), NEW.comment_by,
     1);
  INSERT INTO activity_log (TEXT, user_id, category) VALUES
    (CONCAT("Comment ", NEW.comment, " added on task ", NEW.project_task_id), NEW.comment_by,
     1);
END;
$$

DELIMITER ;





DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_dependentTask_add`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_dependentTask_add` AFTER INSERT ON `dependent_task` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("Task ", NEW.dependent_task_id," is made dependent on task ",NEW.task_id, " by user ", NEW.created_by), 11);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("Task ", NEW.dependent_task_id," is made dependent on task ",NEW.task_id, " by user ", NEW.created_by), NEW.created_by, 11);
END;
$$

DELIMITER ;






DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_plannedActualCost_add`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_plannedActualCost_add` AFTER INSERT ON `planned_actuals_cost` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("New planned cost added for task ", NEW.task_id, " by user ", NEW.created_by), 6);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("New planned cost added for task ", " by ", NEW.created_by, NEW.task_id), NEW.created_by, 6);
END;
$$

DELIMITER ;






DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_plannedActualCost_update`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_plannedActualCost_update` AFTER UPDATE ON `planned_actuals_cost` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("planned cost updated for task ", NEW.task_id, " by user ", NEW.modified_by), 7);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("planned cost updated for task ", NEW.task_id, " by ", NEW.modified_by), NEW.modified_by, 7);
END;
$$

DELIMITER ;





DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_projectMember_add`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_projectMember_add` AFTER INSERT ON `project_member` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("New member ", NEW.user_id," added for project ",NEW.project_id), 8);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("New member ", NEW.user_id," added for project ",NEW.project_id), NEW.user_id, 8);
END;
$$

DELIMITER ;





DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_projectTaskFile_add`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_projectTaskFile_add` AFTER INSERT ON `project_task_files` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("New file ", NEW.file_name," uploaded for task ",NEW.project_task_id, " by user ", NEW.created_by), 10);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("New file ", NEW.file_name," uploaded for task ",NEW.project_task_id, " by user ", NEW.created_by), NEW.created_by, 10);
END;
$$

DELIMITER ;




DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_task_add`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_task_add` AFTER INSERT ON `project_task` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("New task ", NEW.title, " of id ", New.project_task_id , " added by ", NEW.created_by), 4);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("New task ", NEW.title, " of id ", New.project_task_id , " added by ", NEW.created_by), NEW.created_by, 4);
END;
$$

DELIMITER ;





DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_task_update`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_task_update` AFTER UPDATE ON `project_task` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("task ", NEW.title, " of id ", New.project_task_id , " updated by ", NEW.modified_by), 5);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("task ", NEW.title, " of id ", New.project_task_id , " updated by ", NEW.modified_by), NEW.created_by, 5);
END;
$$

DELIMITER ;











DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `log_taskAssignee_add`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `log_taskAssignee_add` AFTER INSERT ON `task_assignee` 
    FOR EACH ROW BEGIN
INSERT INTO activity_log (TEXT, category) VALUES (CONCAT("New assignee ", NEW.task_assignee," added for task ",NEW.project_task_id), 9);
INSERT INTO user_notification (TEXT, user_id, category) VALUES (CONCAT("New assignee ", NEW.task_assignee," added for task ",NEW.task_assignee), NEW.task_assignee, 9);
END;
$$

DELIMITER ;





DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `project_AFTER_INSERT`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `project_AFTER_INSERT` AFTER INSERT ON `project` 
    FOR EACH ROW BEGIN
DECLARE ppId BIGINT;
   SELECT project_parent_id INTO ppId FROM  project WHERE project_id= NEW.project_id;    INSERT INTO activity_log (TEXT, user_id,category,ts_insert,project_id) VALUES
     (CONCAT("New Activity ", NEW.project_name, " added by ", get_userNameById(NEW.project_owner_id)),
      New.created_by,2, NOW(),ppId);
END;
$$

DELIMITER ;





DELIMITER $$

USE `ontarget`$$

DROP TRIGGER /*!50032 IF EXISTS */ `project_AFTER_UPDATE`$$

CREATE
    /*!50017 DEFINER = 'ontarget'@'localhost' */
    TRIGGER `project_AFTER_UPDATE` AFTER UPDATE ON `project` 
    FOR EACH ROW BEGIN
DECLARE ppId BIGINT;
SELECT project_parent_id INTO ppId FROM  project WHERE project_id= OLD.project_id;INSERT INTO activity_log (TEXT, user_id,category,ts_insert,project_id) VALUES
 (CONCAT("Activity ", NEW.project_name, " updated by ", get_userNameById(NEW.project_owner_id)),
  New.created_by,2, NOW(),ppId);
  END;
$$

DELIMITER ;

