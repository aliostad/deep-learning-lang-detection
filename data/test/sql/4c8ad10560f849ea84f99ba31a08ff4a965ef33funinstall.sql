# Sequel Pro dump
# Version 2492
# http://code.google.com/p/sequel-pro
#
# Host: 127.0.0.1 (MySQL 5.1.52)
# Database: wolf
# Generation Time: 2010-12-28 19:20:46 +0000
# ************************************************************


# Dump of table wlf_page
# ------------------------------------------------------------

DELETE FROM `{prefix}page` WHERE `behavior_id` = 'tagger';


# Dump of table wlf_page_part
# ------------------------------------------------------------

DELETE FROM `{prefix}page_part` WHERE `page_id` = '{page_id}';


# Dump of table wlf_snippet
# ------------------------------------------------------------

DELETE FROM `{prefix}snippet` WHERE `name` = 'tags';
DELETE FROM `{prefix}snippet` WHERE `name` = 'tagger_tpl_default';
DELETE FROM `{prefix}snippet` WHERE `name` = 'tagger_tpl_count';