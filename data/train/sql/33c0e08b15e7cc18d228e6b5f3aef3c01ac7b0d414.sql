# --- !Ups

CREATE TABLE `topic_read_statuses` (`topic_id` BIGINT NOT NULL, `user_id` BIGINT NOT NULL);

ALTER TABLE `topic_read_statuses` ADD PRIMARY KEY (`topic_id`, `user_id`);
ALTER TABLE `topic_read_statuses` ADD CONSTRAINT `topic_read_status_topic_fk` FOREIGN KEY(`topic_id`) REFERENCES `topics`(`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `topic_read_statuses` ADD CONSTRAINT `topic_read_status_user_fk` FOREIGN KEY(`user_id`) REFERENCES `users`(`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE TABLE `comment_read_statuses` (`comment_id` BIGINT NOT NULL, `user_id` BIGINT NOT NULL);

ALTER TABLE `comment_read_statuses` ADD PRIMARY KEY (`comment_id`, `user_id`);
ALTER TABLE `comment_read_statuses` ADD CONSTRAINT `comment_read_status_comment_fk` FOREIGN KEY(`comment_id`) REFERENCES `comments`(`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `comment_read_statuses` ADD CONSTRAINT `comment_read_status_user_fk` FOREIGN KEY(`user_id`) REFERENCES `users`(`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;

# --- !Downs

DROP TABLE `topic_read_statuses`;
DROP TABLE `comment_read_statuses`;