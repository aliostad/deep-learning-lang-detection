-- ----------------------------
-- Table structure for `sas_main_menu`
-- ----------------------------
DROP TABLE IF EXISTS `sas_main_menu`;
CREATE TABLE `sas_main_menu` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `page` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sas_main_menu
-- ----------------------------
INSERT INTO `sas_main_menu` VALUES ('1', 'Home', 'home');
INSERT INTO `sas_main_menu` VALUES ('2', 'Apache', 'mysql');
INSERT INTO `sas_main_menu` VALUES ('3', 'Postfix', 'apache');
INSERT INTO `sas_main_menu` VALUES ('4', 'FTP', 'postfix');
INSERT INTO `sas_main_menu` VALUES ('5', 'MySQL', 'ftp');
INSERT INTO `sas_main_menu` VALUES ('6', 'Samba', 'samba');
INSERT INTO `sas_main_menu` VALUES ('7', 'Control', 'management');
INSERT INTO `sas_main_menu` VALUES ('8', 'Webuser', 'webuser');
INSERT INTO `sas_main_menu` VALUES ('9', 'Tools', 'tools');
INSERT INTO `sas_main_menu` VALUES ('10', 'Plugins', 'plugins');

-- ----------------------------
-- Table structure for `sas_mysql_users`
-- ----------------------------
DROP TABLE IF EXISTS `sas_mysql_users`;
CREATE TABLE `sas_mysql_users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `serverid` int(10) NOT NULL,
  `user` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `host` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sas_mysql_users
-- ----------------------------
INSERT INTO `sas_mysql_users` VALUES ('1', '1', 'root', '123', '127.0.0.1');

-- ----------------------------
-- Table structure for `sas_page_content`
-- ----------------------------
DROP TABLE IF EXISTS `sas_page_content`;
CREATE TABLE `sas_page_content` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `page` varchar(255) NOT NULL,
  `spage` varchar(255) NOT NULL,
  `inc_path` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sas_page_content
-- ----------------------------
INSERT INTO `sas_page_content` VALUES ('1', 'home', '', 'includes/content/home/home.inc.php');
INSERT INTO `sas_page_content` VALUES ('2', 'tools', 'console', 'inc/tools/console.inc.php');
INSERT INTO `sas_page_content` VALUES ('3', 'home', 'overview', 'inc/index/overview.inc.php');
INSERT INTO `sas_page_content` VALUES ('4', 'home', 'panel', 'inc/index/panel.inc.php');
INSERT INTO `sas_page_content` VALUES ('5', 'home', 'stats', 'inc/index/stats.inc.php');
INSERT INTO `sas_page_content` VALUES ('6', 'home', 'doku', 'inc/index/doku.inc.php');
INSERT INTO `sas_page_content` VALUES ('7', 'home', 'help', 'inc/index/help.inc.php');
INSERT INTO `sas_page_content` VALUES ('8', 'home', 'about', 'inc/index/about.inc.php');
INSERT INTO `sas_page_content` VALUES ('9', 'mysql', 'console', 'inc/mysql/sqlcmd.inc.php');
INSERT INTO `sas_page_content` VALUES ('10', 'mysql', '', 'inc/mysql/overview.inc.php');
INSERT INTO `sas_page_content` VALUES ('11', 'apache', '', 'inc/apache/overview.inc.php');
INSERT INTO `sas_page_content` VALUES ('12', 'postfix', '', 'inc/postfix/overview.inc.php');
INSERT INTO `sas_page_content` VALUES ('13', 'ftp', '', 'inc/ftp/overview.inc.php');
INSERT INTO `sas_page_content` VALUES ('14', 'samba', '', 'inc/samba/overview.inc.php');
INSERT INTO `sas_page_content` VALUES ('15', 'management', '', 'inc/management/overview.inc.php');

-- ----------------------------
-- Table structure for `sas_side_nav`
-- ----------------------------
DROP TABLE IF EXISTS `sas_side_nav`;
CREATE TABLE `sas_side_nav` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `page` varchar(255) NOT NULL,
  `spage` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sas_side_nav
-- ----------------------------
INSERT INTO `sas_side_nav` VALUES ('1', 'Home', 'home', '');
INSERT INTO `sas_side_nav` VALUES ('2', 'Konsole', 'tools', 'console');
INSERT INTO `sas_side_nav` VALUES ('3', 'System&uuml;bersicht', 'home', 'overview');
INSERT INTO `sas_side_nav` VALUES ('4', 'QuickPanel', 'home', 'panel');
INSERT INTO `sas_side_nav` VALUES ('5', 'Serverstatistiken', 'home', 'stats');
INSERT INTO `sas_side_nav` VALUES ('6', 'Dokumentation', 'home', 'doku');
INSERT INTO `sas_side_nav` VALUES ('7', 'Hilfe', 'home', 'help');
INSERT INTO `sas_side_nav` VALUES ('8', '&Uuml;ber SAS', 'home', 'about');
INSERT INTO `sas_side_nav` VALUES ('9', 'Konsole', 'mysql', 'console');

-- ----------------------------
-- Table structure for `sas_web_users`
-- ----------------------------
DROP TABLE IF EXISTS `sas_web_users`;
CREATE TABLE `sas_web_users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userunique` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of sas_web_users
-- ----------------------------
INSERT INTO `sas_web_users` VALUES ('1', 'admin', 'e8636ea013e682faf61f56ce1cb1ab5c', 'admin@admin.de');
INSERT INTO `sas_web_users` VALUES ('2', 'pat', '22222', 'test@test.de');
