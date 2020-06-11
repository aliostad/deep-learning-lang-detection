-- Add new survey redirect and expiration options
ALTER TABLE  `redcap_surveys` ADD  `end_survey_redirect_url` TEXT NULL COMMENT  'URL to redirect to after completing survey';
ALTER TABLE  `redcap_surveys` ADD  `survey_expiration` VARCHAR( 50 ) NULL COMMENT  'Timestamp when survey expires';
ALTER TABLE  `redcap_surveys` ADD  `end_survey_redirect_url_append_id` INT( 1 ) NOT NULL DEFAULT  '0' COMMENT  'Append participant_id to URL' AFTER  `end_survey_redirect_url`;
-- Add new cron job
INSERT INTO `redcap_crons` (`cron_name` ,`cron_description` ,`cron_enabled` ,`cron_frequency` ,`cron_max_run_time` ,`cron_last_run_end` ,`cron_status` ,`cron_times_failed`)
	VALUES ('ExpireSurveys',  'For any surveys where an expiration timestamp is set, if the timestamp <= NOW, then make the survey inactive.',  'ENABLED',  '120',  '600', NULL ,  'NOT YET RUN',  '0');
-- Change validation table data type
update redcap_validation_types set data_type = 'number' where data_type = 'number_fixeddp';