-- Add new table for Survey Login functionality
CREATE TABLE `redcap_surveys_login` (
`ts` datetime DEFAULT NULL,
`response_id` int(10) DEFAULT NULL,
`login_success` tinyint(1) NOT NULL DEFAULT '1',
KEY `response_id` (`response_id`),
KEY `ts_response_id_success` (`ts`,`response_id`,`login_success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
ALTER TABLE `redcap_surveys_login`
	ADD FOREIGN KEY (`response_id`) REFERENCES `redcap_surveys_response` (`response_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE  `redcap_projects` ADD  `survey_auth_enabled` INT( 1 ) NOT NULL DEFAULT  '0' AFTER  `survey_queue_custom_text`;
ALTER TABLE  `redcap_surveys` ADD  `survey_auth_enabled_single` INT( 1 ) NOT NULL DEFAULT  '0'
	COMMENT  'Enable Survey Login for this single survey?' AFTER  `promis_skip_question`;
ALTER TABLE  `redcap_surveys_participants`
	ADD  `access_code` VARCHAR( 9 ) NULL DEFAULT NULL AFTER  `legacy_hash` ,
	ADD UNIQUE (`access_code`);
-- Add new table for Survey Short Code functionality
CREATE TABLE `redcap_surveys_short_codes` (
`ts` datetime DEFAULT NULL,
`participant_id` int(10) DEFAULT NULL,
`code` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
UNIQUE KEY `code` (`code`),
KEY `participant_id_ts` (`participant_id`,`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
ALTER TABLE `redcap_surveys_short_codes`
	ADD FOREIGN KEY (`participant_id`) REFERENCES `redcap_surveys_participants` (`participant_id`) ON DELETE CASCADE ON UPDATE CASCADE;
-- Add new cron job
INSERT INTO redcap_crons (cron_name, cron_description, cron_enabled, cron_frequency, cron_max_run_time, cron_instances_max, cron_instances_current, cron_last_run_end, cron_times_failed, cron_external_url) VALUES
('ClearSurveyShortCodes', 'Clear all survey short codes older than X minutes.',  'ENABLED',  300,  60,  1,  0, NULL , 0, NULL);
-- Remove the column end_survey_redirect_url_append_id in redcap_surveys table
update redcap_surveys s set s.end_survey_redirect_url_append_id = 0, s.end_survey_redirect_url = concat(s.end_survey_redirect_url, if(LOCATE('?', s.end_survey_redirect_url)=0, '?', '&'),
	'participant_id=[', (select m.field_name from redcap_metadata m where m.project_id = s.project_id order by m.field_order limit 1), ']')
	where s.end_survey_redirect_url_append_id = 1;
ALTER TABLE  `redcap_surveys` DROP  `end_survey_redirect_url_append_id`;