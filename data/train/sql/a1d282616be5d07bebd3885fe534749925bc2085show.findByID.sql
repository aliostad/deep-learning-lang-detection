SELECT `a104_show`.`id`,
       `a104_presenter-user`.`user_id`,
       `a104_show`.`presenter_id`,
       `name` AS `presenter_name`,
       `a104_show`.`slug`,
       `a104_show`.`photo_id`,
       `filename` AS `photo_filename`,
       `title`,
       `description`,
       `duration`
FROM   `a104_show`
       JOIN `a104_presenter`
         ON `a104_show`.`presenter_id` = `a104_presenter`.`id`
       LEFT JOIN `a104_presenter-user`
              ON `a104_show`.`presenter_id` =
                 `a104_presenter-user`.`presenter_id`
       LEFT JOIN `a104_photo`
              ON `a104_show`.`photo_id` = `a104_photo`.`id`
WHERE  `a104_show`.`id` =? 
