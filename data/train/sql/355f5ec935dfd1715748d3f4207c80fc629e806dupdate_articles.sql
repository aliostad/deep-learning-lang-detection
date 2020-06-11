alter table writers drop index writer_type_UNIQUE;
ALTER TABLE `users_log` drop FOREIGN KEY `fk_users_log_user_actions`;
ALTER TABLE `users_log` ADD CONSTRAINT `fk_users_log_user_actions` FOREIGN KEY (`action_id`) REFERENCES `actions` (`action_id`) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE  `articles_translation` CHANGE  `article_detail`  `article_detail` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
alter table writers change `writer_type` `writer_type` TINYINT(3) UNSIGNED NOT NULL DEFAULT 1;
update writers set  `writer_type`  = 1;

CREATE TABLE IF NOT EXISTS `essays` (
  `article_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`article_id`),
  CONSTRAINT `fk_news_articles0`
    FOREIGN KEY (`article_id`)
    REFERENCES `articles` (`article_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


INSERT INTO `modules_components` (`component_id`, `module_id`, `route`) VALUES ('16', '54', 'articles/default/view');
INSERT INTO `modules_components` (`component_id`, `module_id`, `route`) VALUES ('17', '54', 'articles/default/sections');
INSERT INTO `modules_components_translation` (`component_id`, `content_lang`, `component_name`) VALUES ('16', 'en', 'View Article');
INSERT INTO `modules_components_translation` (`component_id`, `content_lang`, `component_name`) VALUES ('16', 'ar', 'عرض المقال');
INSERT INTO `modules_components_translation` (`component_id`, `content_lang`, `component_name`) VALUES ('17', 'en', 'Articles Sections');
INSERT INTO `modules_components_translation` (`component_id`, `content_lang`, `component_name`) VALUES ('17', 'ar', 'أقسام المقالات');
INSERT INTO `modules_components_params` (`component_id`, `param_id`) VALUES ('16', '1');
INSERT INTO `modules_components_params` (`component_id`, `param_id`) VALUES ('17', '1');
INSERT INTO `modules_components_params` (`component_id`, `param_id`) VALUES ('17', '2');
INSERT INTO `modules_components_params` (`component_id`, `param_id`) VALUES ('17', '6');

INSERT INTO `moduls_components_params_translation` (`content_lang`, `component_id`, `param_id`, `label`, `description`) VALUES
('ar', 16, 1, 'عنوان المقال', NULL),
('ar', 17, 1, 'عنوان القسم', NULL),
('ar', 17, 2, 'اضافة الاقسام الفرعيه للقائمة', NULL),
('ar', 17, 6, 'module', NULL),
('en', 16, 1, 'Article title', NULL),
('en', 17, 1, 'Section title', NULL),
('en', 17, 2, 'Append sub-sections to the menu list', NULL),
('en', 17, 6, 'module', NULL);