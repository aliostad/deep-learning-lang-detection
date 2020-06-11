-- MySQL dump 10.13  Distrib 5.6.10, for Win32 (x86)
--
-- Host: localhost    Database: f2e
-- ------------------------------------------------------
-- Server version	5.6.10


--
-- Table structure for table `append`
--

DROP TABLE IF EXISTS `append`;
CREATE TABLE `append` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `content` text,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Table structure for table `blocked`
--

DROP TABLE IF EXISTS `blocked`;
CREATE TABLE `blocked` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `involved_user_id` int(11) DEFAULT NULL,
  `involved_topic_id` int(11) DEFAULT NULL,
  `trigger_user_id` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `reason` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;

CREATE TABLE `favorite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_user_id` int(11) DEFAULT NULL,
  `involved_type` int(11) DEFAULT NULL,
  `involved_topic_id` int(11) DEFAULT NULL,
  `involved_reply_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `description` text,
  `owner_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `update` datetime DEFAULT NULL,
  `like_count` int(11) DEFAULT NULL,
  `waterfall` int(1) DEFAULT NULL,
  `authority` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
DELIMITER ;;
CREATE TRIGGER `f2e`.`image_delete_trigger`
BEFORE DELETE ON `f2e`.`image`
FOR EACH ROW
BEGIN
        DELETE FROM notification WHERE notification.involved_image_id = OLD.id;
        DELETE FROM imglike WHERE imglike.involved_image_id = OLD.id;
    END ;;
DELIMITER ;


--
-- Table structure for table `imglike`
--

DROP TABLE IF EXISTS `imglike`;
CREATE TABLE `imglike` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_user_id` int(11) DEFAULT NULL,
  `involved_image_id` int(11) DEFAULT NULL,
  `trigger_user_id` int(11) DEFAULT NULL,
  `occurrence_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
CREATE TABLE `node` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `slug` text,
  `thumb` text,
  `introduction` text,
  `created` text,
  `updated` text,
  `plane_id` int(11) DEFAULT NULL,
  `topic_count` int(11) DEFAULT NULL,
  `custom_style` text,
  `limit_reputation` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `status` int(11) DEFAULT NULL,
  `involved_type` int(11) DEFAULT NULL,
  `involved_user_id` int(11) DEFAULT NULL,
  `involved_topic_id` int(11) DEFAULT NULL,
  `involved_reply_id` int(11) DEFAULT NULL,
  `involved_image_id` int(11) DEFAULT NULL,
  `trigger_user_id` int(11) DEFAULT NULL,
  `occurrence_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `plane`
--

DROP TABLE IF EXISTS `plane`;
CREATE TABLE `plane` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `created` text,
  `updated` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
CREATE TABLE `reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `content` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `up_vote` int(11) DEFAULT NULL,
  `down_vote` int(11) DEFAULT NULL,
  `last_touched` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text,
  `content` text,
  `status` int(11) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `node_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `reply_count` int(11) DEFAULT NULL,
  `last_replied_by` text,
  `last_replied_time` datetime DEFAULT NULL,
  `up_vote` int(11) DEFAULT NULL,
  `down_vote` int(11) DEFAULT NULL,
  `last_touched` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
DELIMITER ;;
CREATE TRIGGER `f2e`.`topic_delete_trigger`
BEFORE DELETE ON `f2e`.`topic`
FOR EACH ROW
BEGIN
        DELETE FROM reply WHERE reply.topic_id = OLD.id;
        DELETE FROM append WHERE append.topic_id = OLD.id;
        DELETE FROM notification WHERE notification.involved_topic_id = OLD.id;
        DELETE FROM favorite WHERE favorite.involved_topic_id = OLD.id;
        DELETE FROM vote WHERE vote.involved_topic_id = OLD.id;
        DELETE FROM blocked WHERE blocked.involved_topic_id = OLD.id;
    END ;;
DELIMITER ;


--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
CREATE TABLE `transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) DEFAULT NULL,
  `reward` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `current_balance` int(11) DEFAULT NULL,
  `involved_user_id` int(11) DEFAULT NULL,
  `involved_topic_id` int(11) DEFAULT NULL,
  `involved_reply_id` int(11) DEFAULT NULL,
  `occurrence_time` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `email` text,
  `password` text,
  `username` text,
  `nickname` text,
  `avatar` text,
  `signature` text,
  `location` text,
  `website` text,
  `company` text,
  `role` int(11) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `reputation` int(11) DEFAULT NULL,
  `self_intro` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `twitter` text,
  `github` text,
  `douban` text,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=169 DEFAULT CHARSET=utf8;
DELIMITER ;;
CREATE TRIGGER `user_delete_trigger` BEFORE DELETE ON `user` FOR EACH ROW BEGIN
        DELETE FROM topic WHERE topic.author_id = OLD.uid;
        DELETE FROM reply WHERE reply.author_id = OLD.uid;
        DELETE FROM notification WHERE notification.trigger_user_id = OLD.uid;
        DELETE FROM notification WHERE notification.involved_user_id = OLD.uid;
    END ;;
DELIMITER ;


--
-- Table structure for table `vote`
--

DROP TABLE IF EXISTS `vote`;
CREATE TABLE `vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) DEFAULT NULL,
  `involved_type` int(11) DEFAULT NULL,
  `involved_user_id` int(11) DEFAULT NULL,
  `involved_topic_id` int(11) DEFAULT NULL,
  `involved_reply_id` int(11) DEFAULT NULL,
  `trigger_user_id` int(11) DEFAULT NULL,
  `occurrence_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- Dump completed on 2015-05-01 16:40:00
