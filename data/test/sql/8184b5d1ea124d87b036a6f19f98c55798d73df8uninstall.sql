DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='draw_follow_log' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='draw_follow_log' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_draw_follow_log`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='lottery_prize_list' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='lottery_prize_list' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_lottery_prize_list`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='lucky_follow' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='lucky_follow' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_lucky_follow`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='lzwg_activities' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='lzwg_activities' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_lzwg_activities`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='lzwg_activities_vote' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='lzwg_activities_vote' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_lzwg_activities_vote`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='sport_award' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='sport_award' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_sport_award`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='sports' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='sports' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_sports`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='sports_drum' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='sports_drum' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_sports_drum`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='sports_support' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='sports_support' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_sports_support`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='sports_team' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='sports_team' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_sports_team`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='lottery_games' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='lottery_games' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_lottery_games`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='lottery_games_award_link' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='lottery_games_award_link' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_lottery_games_award_link`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='draw_follow_log' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='draw_follow_log' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_draw_follow_log`;


