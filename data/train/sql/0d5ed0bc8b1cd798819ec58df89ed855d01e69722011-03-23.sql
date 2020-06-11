ALTER TABLE `auto.termi.lv`.`url` ADD COLUMN `last_checked` DATETIME  DEFAULT NULL AFTER `added`;
ALTER TABLE `auto.termi.lv`.`model` ADD COLUMN `total` INT(8)  NOT NULL DEFAULT 0 AFTER `order`;
ALTER TABLE `auto.termi.lv`.`mark` ADD COLUMN `total` INT(8)  NOT NULL DEFAULT 0 AFTER `name`;
ALTER TABLE `auto.termi.lv`.`auto` ADD COLUMN `published` tinyint(1)  NOT NULL DEFAULT 1 AFTER `telephone`;
ALTER TABLE `auto.termi.lv`.`auto` ADD COLUMN `correct` tinyint(1)  NOT NULL DEFAULT 1 AFTER `published`;

CREATE TRIGGER `auto.termi.lv`.`insert_auto`
AFTER INSERT ON `auto` FOR EACH ROW
BEGIN
	UPDATE `model`
	SET `total`=(SELECT COUNT(`id`) FROM `auto` WHERE model_id=NEW.model_id AND `published`=1) WHERE `id`=NEW.model_id;
END
;

CREATE TRIGGER `auto.termi.lv`.`update_auto`
AFTER UPDATE ON `auto` FOR EACH ROW
BEGIN
	UPDATE `model`
	SET `total`=(SELECT COUNT(`id`) FROM `auto` WHERE model_id=NEW.model_id AND `published`=1) WHERE `id`=NEW.model_id;
	SET `total`=(SELECT COUNT(`id`) FROM `auto` WHERE model_id=OLD.model_id AND `published`=1) WHERE `id`=OLD.model_id;
END
;
CREATE TRIGGER `auto.termi.lv`.`delete_auto`
AFTER DELETE ON `auto` FOR EACH ROW
BEGIN
	UPDATE `model`
	SET `total`=(SELECT COUNT(`id`) FROM `auto` WHERE model_id=OLD.model_id AND `published`=1) WHERE `id`=OLD.model_id;
END
;

CREATE TRIGGER `auto.termi.lv`.`update_model`
AFTER UPDATE ON `model` FOR EACH ROW
BEGIN
	UPDATE `mark`
	SET `total`=(SELECT SUM(`total`) FROM `model` WHERE mark_id=NEW.mark_id) WHERE `id`=NEW.mark_id;
END
;


