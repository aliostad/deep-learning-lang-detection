SELECT `a104_schedule`.`id`,
       `show_id`,
       `name`             AS `presenter_name`,
       `a104_show`.`slug` AS `show_slug`,
       `title`            AS `show_title`,
       `day`,
       `time`,
       `duration`,
       `is_repeat`,
       `enable_webcam`,
       `description`      AS `show_description`
FROM   `a104_schedule`
       JOIN `a104_show`
         ON `a104_show`.`id` = `show_id`
       JOIN `a104_presenter`
         ON `a104_presenter`.`id` = `presenter_id`
WHERE  `visible` = true
ORDER  BY `day` ASC,
          `time` ASC 
