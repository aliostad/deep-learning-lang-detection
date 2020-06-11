
-- UserOnlineService.offline()
CREATE
    TRIGGER `trigger_sys_user_off_online` AFTER DELETE ON `sys_user_online`
    FOR EACH ROW BEGIN
   IF OLD.`user_id` IS NOT NULL THEN
      IF NOT EXISTS(SELECT `user_id` FROM `sys_user_last_online` WHERE `user_id` = OLD.`user_id`) THEN
        INSERT INTO `sys_user_last_online`
                  (`user_id`, `username`, `uid`, `host`, `user_agent`, `system_host`,
                   `last_login_timestamp`, `last_stop_timestamp`, `login_count`, `total_online_time`)
                VALUES
                   (OLD.`user_id`,OLD.`username`, OLD.`id`, OLD.`host`, OLD.`user_agent`, OLD.`system_host`,
                    OLD.`start_timestamp`, OLD.`last_access_time`,
                    1, (OLD.`last_access_time` - OLD.`start_timestamp`));
      ELSE
        UPDATE `sys_user_last_online`
          SET `username` = OLD.`username`, `uid` = OLD.`id`, `host` = OLD.`host`, `user_agent` = OLD.`user_agent`,
            `system_host` = OLD.`system_host`, `last_login_timestamp` = OLD.`start_timestamp`,
             `last_stop_timestamp` = OLD.`last_access_time`, `login_count` = `login_count` + 1,
             `total_online_time` = `total_online_time` + (OLD.`last_access_time` - OLD.`start_timestamp`)
        WHERE `user_id` = OLD.`user_id`;
      END IF ;
   END IF;
END;

DELIMITER $$

CREATE
    TRIGGER `order_payment_entry_cascade_delete` BEFORE DELETE
    ON `order_payment_scenarios`
    FOR EACH ROW BEGIN
DELETE FROM `order_payment_entry` WHERE `ps_id` = OLD.`id`;
    END$$

DELIMITER ;