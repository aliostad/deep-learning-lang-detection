-- Inserting of new opinion
DROP TRIGGER IF EXISTS `feed_new_opinion`;
CREATE TRIGGER `feed_new_opinion` AFTER INSERT ON `opinion`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
		'new_opinion',
		NEW.`id_user`,
		NOW(),
		(SELECT CONCAT_WS('#$#',`id_book_title`,`book_title`,IFNULL(REPLACE(`content`,'#$#',''), ''),`rating`) FROM `view_opinion` WHERE `id_opinion` = NEW.`id_opinion`)
	);

-- Updating of old opinion
DROP TRIGGER IF EXISTS `feed_updated_opinion`;
DELIMITER $$
CREATE TRIGGER `feed_updated_opinion` AFTER UPDATE ON `opinion`
FOR EACH ROW
BEGIN
	IF OLD.`content` != NEW.`content` OR OLD.`rating` != NEW.`rating`  THEN
		INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
			'updated_opinion',
			NEW.`id_user`,
			NOW(),
			(SELECT CONCAT_WS('#$#',`id_book_title`,`book_title`,IFNULL(REPLACE(`content`,'#$#',''), ''),IFNULL(REPLACE(OLD.`content`,'#$#',''), ''),`rating`,OLD.`rating`) FROM `view_opinion` WHERE `id_opinion` = NEW.`id_opinion`)
		);
	END IF;
END $$
DELIMITER ;

-- Insert book into shelf
DROP TRIGGER IF EXISTS `feed_shelved`;
CREATE TRIGGER `feed_shelved` AFTER INSERT ON `in_shelf`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
		'shelved',
		(SELECT `id_user` FROM `view_shelf_book` WHERE `id_in_shelf` = NEW.`id_in_shelf`),
		NOW(),
		(SELECT CONCAT_WS('#$#',`type`,`name`,`id_book_title`,IFNULL(REPLACE(`title`,'#$#',''),''),IFNULL(REPLACE(`subtitle`,'#$#',''),'')) FROM `view_shelf_book` WHERE `id_in_shelf` = NEW.`id_in_shelf`)
	);

-- Delete book from shelf
DROP TRIGGER IF EXISTS `feed_deshelved`;
CREATE TRIGGER `feed_deshelved` BEFORE DELETE ON `in_shelf`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
		'deshelved',
		(SELECT `id_user` FROM `view_shelf_book` WHERE `id_in_shelf` = OLD.`id_in_shelf`),
		NOW(),
		(SELECT CONCAT_WS('#$#',`type`,`name`,`id_book_title`,IFNULL(REPLACE(`title`,'#$#',''),''),IFNULL(REPLACE(`subtitle`,'#$#',''),'')) FROM `view_shelf_book` WHERE `id_in_shelf` = OLD.`id_in_shelf`)
	);

-- New follower (for others followers)
DROP TRIGGER IF EXISTS `feed_new_follower`;
CREATE TRIGGER `feed_new_follower` AFTER INSERT ON `following`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
		'new_follower',
		NEW.`id_user`,
		NOW(),
		(SELECT CONCAT_WS('#$#',`id_user`,IFNULL(REPLACE(`nick`,'#$#',''),'')) FROM `user` WHERE `id_user` = NEW.`id_user_followed`)
	);

-- New book
DROP TRIGGER IF EXISTS `feed_new_book`;
CREATE TRIGGER `feed_new_book` AFTER INSERT ON `book_title`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
		'new_book',
		NULL,	-- Do not have real owner
		NOW(),
		CONCAT_WS('#$#',NEW.`id_book_title`,NEW.`title`,NEW.`subtitle`)
	);

-- New discussion (only topics)
DROP TRIGGER IF EXISTS `feed_new_discussion`;
CREATE TRIGGER `feed_new_discussion` AFTER INSERT ON `topic`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
		'new_discussion',
		NEW.`id_user`,
		NOW(),
		CONCAT_WS('#$#',NEW.`id_topic`,NEW.`name`)
	);

-- New post (topics and disccussion of topics)
DROP TRIGGER IF EXISTS `feed_new_post`;
CREATE TRIGGER `feed_new_post` AFTER INSERT ON `post`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted, content) VALUES (
		'new_post',
		NEW.`id_user`,
		NOW(),
		(SELECT CONCAT_WS('#$#',`id_discussion`,`discussion_name`,`id_discussable`,`id_discussed`,IFNULL(REPLACE(`subject`,'#$#',''),''),IFNULL(REPLACE(`content`,'#$#',''), '')) FROM `view_post` WHERE `id_post` = NEW.`id_post`)
	);
-- New user
DROP TRIGGER IF EXISTS `feed_new_user`;
CREATE TRIGGER `feed_new_user` AFTER INSERT ON `user`
FOR EACH ROW
	INSERT INTO `feed_event` (type, id_user, inserted) VALUES (
		'new_user',
		NEW.`id_user`,
		NOW()
	);
