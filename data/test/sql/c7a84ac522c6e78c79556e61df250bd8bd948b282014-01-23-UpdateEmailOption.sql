ALTER TABLE  `channel_email_option` 
ADD  `protocol` VARCHAR( 255 ) NULL AFTER  `folder` ,
ADD  `to_filter` VARCHAR( 255 ) NULL AFTER  `protocol` ,
ADD  `from_filter` VARCHAR( 255 ) NULL AFTER  `to_filter` ,
ADD  `subject_filter` VARCHAR( 255 ) NULL AFTER  `from_filter` ,
ADD  `cc_filter` VARCHAR( 255 ) NULL AFTER  `subject_filter` ,
ADD  `body_filter` VARCHAR( 255 ) NULL AFTER  `cc_filter` ,
ADD  `post_read_action` VARCHAR( 255 ) NULL AFTER  `body_filter` ,
ADD  `post_read_parameter` VARCHAR( 255 ) NULL AFTER  `post_read_action`;

ALTER TABLE  `channel` ADD  `do_processing` TINYINT( 1 ) NOT NULL DEFAULT  '1' AFTER  `notify_user_id`;

ALTER TABLE  `channel_message` CHANGE  `channel_type`  `message_type` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL;

