CREATE DATABASE  IF NOT EXISTS `ezegarraDB` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ezegarraDB`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql.cs.pitt.edu    Database: ezegarraDB
-- ------------------------------------------------------
-- Server version	5.0.45-community-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Not dumping tablespaces as no INFORMATION_SCHEMA.FILES table on this server
--

--
-- Table structure for table `qa_options`
--

DROP TABLE IF EXISTS `qa_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qa_options` (
  `title` varchar(40) NOT NULL,
  `content` varchar(8000) NOT NULL,
  PRIMARY KEY  (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qa_options`
--

LOCK TABLES `qa_options` WRITE;
/*!40000 ALTER TABLE `qa_options` DISABLE KEYS */;
INSERT INTO `qa_options` VALUES ('adsense_publisher_id',''),('allow_change_usernames','1'),('allow_multi_answers','1'),('allow_no_category',''),('allow_no_sub_category',''),('allow_private_messages','0'),('allow_view_q_bots','0'),('avatar_allow_gravatar','1'),('avatar_allow_upload','1'),('avatar_default_blobid',''),('avatar_default_height',''),('avatar_default_show','0'),('avatar_default_width',''),('avatar_profile_size','200'),('avatar_q_list_size','0'),('avatar_q_page_a_size','40'),('avatar_q_page_c_size','20'),('avatar_q_page_q_size','50'),('avatar_store_size','400'),('avatar_users_size','30'),('block_bad_words',''),('block_ips_write',''),('cache_acount','99'),('cache_ccount','47'),('cache_qcount','88'),('cache_tagcount','0'),('cache_unaqcount','6'),('cache_userpointscount','91'),('captcha_on_anon_post','1'),('captcha_on_feedback','1'),('captcha_on_register','1'),('captcha_on_reset_password','1'),('captcha_on_unconfirmed','0'),('columns_tags','3'),('columns_users','2'),('comment_on_as','1'),('comment_on_qs','1'),('confirm_user_emails','1'),('custom_footer',''),('custom_header',''),('custom_home_content','<div class=\"microprobe-welcome-panel\">\n<div class=\"microprobe-welcome-title\">\nWelcome to MicroProbe\n</div>\n\n<p>The MicroProbe system is based on the Question2Answer application.  The main purpose of the system is to allow students to collaborate with each other as part of their course requirements.  \n</p>\n<p>\nThis is an experimental system and frequent changes will be occurring as further enhancements are added.\n</p>\n</div>'),('custom_home_heading',''),('custom_in_head',''),('custom_sidebar','This is an experimental/research application.  Usage information is monitored to learn about usage patterns.'),('custom_sidepanel',''),('custom_welcome',''),('db_version','30'),('do_ask_check_qs','0'),('do_complete_tags','1'),('do_count_q_views','1'),('do_example_tags','1'),('do_related_qs','0'),('editor_for_as','WYSIWYG Editor'),('editor_for_cs',''),('editor_for_qs','WYSIWYG Editor'),('email_privacy','Privacy: Your email address will not be shared or sold to third parties.'),('event_logger_directory',''),('event_logger_hide_header',''),('event_logger_to_database','1'),('event_logger_to_files',''),('facebook_app_id',''),('facebook_app_secret',''),('feedback_email','ezegarra@cs.pitt.edu'),('feedback_enabled','1'),('feed_for_activity','0'),('feed_for_hot','0'),('feed_for_qa','0'),('feed_for_questions','0'),('feed_for_search','0'),('feed_for_tag_qs',''),('feed_for_unanswered','0'),('feed_full_text','0'),('feed_number_items','50'),('feed_per_category','0'),('flagging_hide_after','5'),('flagging_notify_every','2'),('flagging_notify_first','1'),('flagging_of_posts','1'),('follow_on_as','1'),('from_email','ezegarra@cs.pitt.edu'),('home_description',''),('hot_weight_answers','100'),('hot_weight_a_age','100'),('hot_weight_q_age','100'),('hot_weight_views','100'),('hot_weight_votes','100'),('links_in_new_window','0'),('logo_height',''),('logo_show','0'),('logo_url','http://www.cs.pitt.edu/images/banner-logo.gif'),('logo_width',''),('match_ask_check_qs','3'),('match_example_tags','3'),('match_related_qs','3'),('max_len_q_title','120'),('max_num_q_tags','5'),('max_rate_ip_as','50'),('max_rate_ip_cs','40'),('max_rate_ip_flags','10'),('max_rate_ip_logins','20'),('max_rate_ip_messages','10'),('max_rate_ip_qs','20'),('max_rate_ip_uploads','20'),('max_rate_ip_votes','600'),('max_rate_user_as','25'),('max_rate_user_cs','20'),('max_rate_user_flags','5'),('max_rate_user_messages','5'),('max_rate_user_qs','10'),('max_rate_user_uploads','10'),('max_rate_user_votes','300'),('min_len_a_content','12'),('min_len_c_content','12'),('min_len_q_content','0'),('min_len_q_title','12'),('min_num_q_tags','0'),('mouseover_content_max_len','480'),('mouseover_content_on',''),('mp_active_category','3'),('nav_activity','0'),('nav_categories','0'),('nav_home','0'),('nav_hot','0'),('nav_qa_is_home','0'),('nav_qa_not_home','0'),('nav_questions','1'),('nav_tags','0'),('nav_unanswered','1'),('nav_users','0'),('neat_urls','4'),('notify_admin_q_post','0'),('notify_users_default','1'),('pages_prev_next','3'),('page_size_activity','20'),('page_size_ask_check_qs','5'),('page_size_ask_tags','5'),('page_size_home','20'),('page_size_hot_qs','20'),('page_size_qs','20'),('page_size_related_qs','5'),('page_size_search','10'),('page_size_tags','30'),('page_size_tag_qs','20'),('page_size_una_qs','20'),('page_size_users','20'),('page_size_user_posts','20'),('permit_anon_view_ips','70'),('permit_anon_view_ips_points',''),('permit_delete_hidden','40'),('permit_delete_hidden_points',''),('permit_edit_a','100'),('permit_edit_a_points',''),('permit_edit_c','70'),('permit_edit_c_points',''),('permit_edit_q','70'),('permit_edit_q_points',''),('permit_flag','110'),('permit_flag_points',''),('permit_hide_show','70'),('permit_hide_show_points',''),('permit_post_a','120'),('permit_post_a_points',''),('permit_post_c','120'),('permit_post_c_points',''),('permit_post_q','120'),('permit_post_q_points',''),('permit_select_a','100'),('permit_select_a_points',''),('permit_view_q_page','120'),('permit_vote_a','120'),('permit_vote_a_points',''),('permit_vote_q','120'),('permit_vote_q_points',''),('points_a_selected','30'),('points_a_voted_max_gain','20'),('points_a_voted_max_loss','5'),('points_base','100'),('points_multiple','10'),('points_per_a_voted','2'),('points_per_q_voted','1'),('points_post_a','4'),('points_post_q','2'),('points_q_voted_max_gain','10'),('points_q_voted_max_loss','3'),('points_select_a','3'),('points_to_titles','3000 Gold,1500 Silver,500 Bronze'),('points_vote_down_a','1'),('points_vote_down_q','1'),('points_vote_on_a',''),('points_vote_on_q',''),('points_vote_up_a','1'),('points_vote_up_q','1'),('q_urls_remove_accents','0'),('q_urls_title_length','50'),('recaptcha_private_key',''),('recaptcha_public_key',''),('show_a_c_links','1'),('show_a_form_immediate','if_no_as'),('show_custom_footer','0'),('show_custom_header','0'),('show_custom_home','1'),('show_custom_in_head','0'),('show_custom_sidebar','1'),('show_custom_sidepanel','0'),('show_c_reply_buttons','0'),('show_home_description','0'),('show_selected_first','1'),('show_url_links','1'),('show_user_points','0'),('show_user_titles','1'),('show_view_counts',''),('show_when_created','1'),('site_language',''),('site_maintenance','1'),('site_theme','Microprobe'),('site_title','MicroProbe'),('site_url','http://www.cs.pitt.edu/~ezegarra/microprobe/'),('sort_answers_by','created'),('suspend_register_users',''),('tags_or_categories','c'),('tag_cloud_count_tags','100'),('tag_cloud_font_size','24'),('tag_cloud_size_popular','1'),('tag_separator_comma','0'),('votes_separated','0'),('voting_on_as','1'),('voting_on_qs','1'),('voting_on_q_page_only','0'),('wysiwyg_editor_upload_all',''),('wysiwyg_editor_upload_images',''),('wysiwyg_editor_upload_max_size','1048576');
/*!40000 ALTER TABLE `qa_options` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-03-03 14:25:19
