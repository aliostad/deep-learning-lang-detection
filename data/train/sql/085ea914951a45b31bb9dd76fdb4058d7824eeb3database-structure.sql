CREATE TABLE `ilib_category` (
`id` int(11) NOT NULL auto_increment,
`belong_to` int(11) NOT NULL,
`belong_to_id` int(11) NOT NULL,
`parent_id` int(11) NOT NULL,
`name` varchar(255) NOT NULL,
`identifier` varchar(255) NOT NULL,
 PRIMARY KEY  (`id`) );
 
CREATE TABLE IF NOT EXISTS `ilib_category_append` (
`id` int(11) NOT NULL auto_increment,
`object_id` int(11) NOT NULL,
`category_id` int(11) NOT NULL,
PRIMARY KEY  (`id`));

ALTER TABLE `ilib_category` ADD INDEX ( `intranet_id` , `belong_to` , `belong_to_id` )  ;
ALTER TABLE `ilib_category` ADD INDEX ( `parent_id` )  ;
ALTER TABLE `ilib_category_append` ADD INDEX ( `intranet_id` , `object_id` , `category_id` )  ;
ALTER TABLE `ilib_category` ADD `active` INT( 1 ) NOT NULL DEFAULT '1' ;