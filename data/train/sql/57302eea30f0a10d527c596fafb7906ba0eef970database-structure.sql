-- phpMyAdmin SQL Dump
-- version 2.11.0
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 15, 2008 at 11:36 AM
-- Server version: 5.0.45
-- PHP Version: 5.2.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

-- --------------------------------------------------------

--
-- Table structure for table `filehandler_append_file`
--

CREATE TABLE IF NOT EXISTS `filehandler_append_file` (
  `id` int(11) NOT NULL auto_increment,
  `intranet_id` int(11) NOT NULL default '0',
  `date_created` datetime NOT NULL default '0000-00-00 00:00:00',
  `date_updated` datetime NOT NULL default '0000-00-00 00:00:00',
  `belong_to_key` int(11) NOT NULL default '0',
  `belong_to_id` int(11) NOT NULL default '0',
  `file_handler_id` int(11) NOT NULL default '0',
  `description` varchar(255) NOT NULL default '',
  `active` int(1) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `intranet_id` (`intranet_id`,`belong_to_id`,`file_handler_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `file_handler`
--

CREATE TABLE IF NOT EXISTS `file_handler` (
  `id` int(11) NOT NULL auto_increment,
  `intranet_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `date_created` datetime NOT NULL default '0000-00-00 00:00:00',
  `date_changed` datetime NOT NULL default '0000-00-00 00:00:00',
  `description` text NOT NULL,
  `file_name` varchar(100) NOT NULL default '',
  `server_file_name` varchar(255) NOT NULL default '',
  `file_size` int(11) NOT NULL default '0',
  `file_type_key` int(11) NOT NULL default '0',
  `accessibility_key` int(11) NOT NULL default '0',
  `access_key` varchar(255) NOT NULL default '',
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `active` int(11) NOT NULL default '1',
  `temporary` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `intranet_id` (`intranet_id`,`access_key`,`active`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `file_handler_instance`
--

CREATE TABLE IF NOT EXISTS `file_handler_instance` (
  `id` int(11) NOT NULL auto_increment,
  `intranet_id` int(11) NOT NULL default '0',
  `file_handler_id` int(11) NOT NULL default '0',
  `type_key` int(11) NOT NULL default '0',
  `date_created` datetime NOT NULL default '0000-00-00 00:00:00',
  `date_changed` datetime NOT NULL default '0000-00-00 00:00:00',
  `server_file_name` varchar(255) NOT NULL default '',
  `width` int(255) NOT NULL default '0',
  `height` int(255) NOT NULL default '0',
  `file_size` varchar(20) NOT NULL default '',
  `crop_parameter` varchar(255) NOT NULL,
  `active` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `intranet_id` (`intranet_id`,`file_handler_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `file_handler_instance_type`
--

CREATE TABLE IF NOT EXISTS `file_handler_instance_type` (
  `id` int(11) NOT NULL auto_increment,
  `intranet_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type_key` int(11) NOT NULL,
  `max_height` int(11) NOT NULL,
  `max_width` int(11) NOT NULL,
  `resize_type_key` int(11) NOT NULL,
  `active` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

