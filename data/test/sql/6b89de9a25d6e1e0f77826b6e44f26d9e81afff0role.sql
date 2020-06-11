DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `role_id` int(11) NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  `permissions` set('student_edit','order_project','order_activate','user_edit','student_view_short','student_view','news_view','news_edit') NOT NULL default '',
  PRIMARY KEY  (`role_id`)
) TYPE=MyISAM;

INSERT INTO `role` VALUES (1,'Администратор','student_edit,order_project,order_activate,user_edit,student_view_short,student_view,news_view,news_edit');
INSERT INTO `role` VALUES (2,'Работник деканата','student_edit,order_project,student_view_short,student_view,news_view');
INSERT INTO `role` VALUES (3,'Работник УК','student_edit,order_project,order_activate,student_view_short,student_view,news_view');
INSERT INTO `role` VALUES (4,'Администрация МГТУ','student_view_short,student_view,news_view');
