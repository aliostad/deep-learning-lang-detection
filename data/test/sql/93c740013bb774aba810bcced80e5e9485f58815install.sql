CREATE TABLE IF NOT EXISTS `litters`(
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`meta_id` int(11) NOT NULL,
	`language` varchar(5)NOT NULL,
	`mother_id` int(11) NOT NULL,
	`father_id` int(11) NOT NULL,
	`birth_date` date NOT NULL,
	`name` varchar(255)NOT NULL,
	`description_before` text,
	`description_after` text,
	`created_on` datetime NOT NULL,
	`edited_on` datetime NOT NULL,
	`sequence` int(11) NOT NULL,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `litters_parents`(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `meta_id` int(11) NOT NULL,
  `language` varchar(5) NOT NULL,
  `name` varchar(255) NOT NULL,
  `affix` varchar(255) NOT NULL,
  `affix_position` enum('APPEND','PREPEND') NOT NULL,
  `birth_date` date NOT NULL,
  `sex` enum('M','F') NOT NULL,
  `color` varchar(100) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `photo_url` varchar(255) DEFAULT NULL,
  `created_on` datetime NOT NULL,
  `edited_on` datetime NOT NULL,
  `sequence` int(11) NOT NULL,
  PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `litters_youngs`(
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`meta_id` int(11) DEFAULT NULL,
	`litter_id` int(11) NOT NULL,
	`language` varchar(5) NOT NULL,
	`code_name` varchar(255) NOT NULL,
	`name` varchar(255) NOT NULL,
	`sex` enum('M','F','NULL') DEFAULT NULL,
	`color` varchar(100) DEFAULT NULL,
	`ems_code` varchar(15) DEFAULT NULL,
	`quality` enum('NULL','PET','BREEDER','SHOW') DEFAULT NULL,
	`availability` enum('NULL','AVAILABLE','RESERVED','PRERESERVED','KEEPER','GONE') DEFAULT NULL,
	`url` varchar(255) DEFAULT NULL,
	`photo_url` varchar(255) DEFAULT NULL,
	`created_on` datetime NOT NULL,
	`edited_on` datetime NOT NULL,
	`sequence` int(11) NOT NULL,
	PRIMARY KEY(`id`)
);