/** this is not a formal prepared statement
 * it can get all profile or append where statement to filter by account id
 * @remark unsafe
 * */
SELECT
  `User`.`account_id`,
  `Account`.`account_type`,
  `Account`.`email`,
  `Account`.`phone_num`,
  `User`.`sex`,
  `User`.`first_name`,
  `User`.`last_name`,
  `User`.`city`,
  `User`.`country`,
  `User`.`organization`,
  `User`.`title`
#   `Title`.`title_text`  AS `title`,
#   `City`.`city_name`    AS `user_city`,
#   `Organization`.`name` AS `organization_name`,
#   `organization_type`,
#   `country_name`        AS `organization_country`
FROM `social_connection`.`User`
  INNER JOIN `social_connection`.`Account`
    ON `User`.`account_id` = `Account`.`account_id`
    
#   INNER JOIN `social_connection`.`Organization`
#     ON `User`.`organization_id` = `Organization`.`organization_id`

#   INNER JOIN `Title`
#     ON `User`.`title_id` = `Title`.`title_id`

#   INNER JOIN `Country`
#     ON `Organization`.`main_country` = `Country`.`country_id`

#   INNER JOIN `City`
#     ON `User`.`city_id` = `City`.`city_id`

