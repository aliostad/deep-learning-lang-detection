CREATE TABLE IF NOT EXISTS `request_message` (
`request_message_id` int(10) unsigned NOT NULL,
  `request_topic` int(10) unsigned NOT NULL,
  `request_message` text NOT NULL,
  `request_message_date` int(10) unsigned NOT NULL,
  `request_message_user` int(11) NOT NULL,
  `request_message_read` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `request_message`
ADD PRIMARY KEY (`request_message_id`),
ADD KEY `request_topic` (`request_topic`),
ADD KEY `request_message_user` (`request_message_user`),
ADD KEY `request_message_read` (`request_message_read`);

ALTER TABLE `request_message`
MODIFY `request_message_id` int(10) unsigned NOT NULL AUTO_INCREMENT;
