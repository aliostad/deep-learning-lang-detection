SET NAMES utf8;

ALTER TABLE `hotels` DROP COLUMN `description`;

CREATE TABLE `regions` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL,
	`territory_id` BIGINT NOT NULL,
	`health_factors` VARCHAR(255) NULL,
PRIMARY KEY (`id`));
  
CREATE TABLE `resort_zones` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL,
	`territory_id` BIGINT NOT NULL,
	`health_factors` VARCHAR(255) NULL,
PRIMARY KEY (`id`));

ALTER TABLE `countries` 
	CHANGE COLUMN `title` `title` VARCHAR(255) NOT NULL,
	CHANGE COLUMN `territory_id` `territory_id` BIGINT(20) NOT NULL,
	ADD COLUMN `health_factors` VARCHAR(255) NULL AFTER `territory_id`;

INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('20', 'Основная информация', '', 2, 1, 1, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('21', 'Государство, население, язык, виза', 'about', 2, 2, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('22', 'Природные лечебные факторы', 'health-factors', 2, 3, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('23', 'Курортная медицина', 'medicine', 2, 4, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('24', 'Курорты', 'resorts', 2, 5, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('25', 'Как проехать на курорты', 'resorts-map', 2, 6, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('26', 'Достопримечательности', 'sights', 2, 7, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('27', 'Полезные советы', 'advice', 2, 8, 0, 0, 0);

INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('28', 'Основная информация', '', 3, 1, 1, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('29', 'Природные лечебные факторы', 'health-factors', 3, 2, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('30', 'Курорты', 'resorts', 3, 3, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('31', 'Достопримечательности', 'sights', 3, 4, 0, 0, 0);

INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('32', 'Основная информация', '', 4, 1, 1, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('33', 'Из истории курорта', 'history', 4, 2, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('34', 'Природные лечебные факторы', 'health-factors', 4, 3, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('35', 'Курортная медицина', 'medicine', 4, 4, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('36', 'Основные показания для лечения', 'treatments', 4, 5, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('37', 'Спорт', 'sport', 4, 6, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('38', 'Досуг', 'leisure', 4, 7, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('39', 'Достопримечательности, экскурсии', 'sights', 4, 8, 0, 0, 0);
INSERT INTO `fieldsets` (`id`, `title`, `url`, `entity_type`, `order_number`, `show_gallery`, `show_map`, `show_in_anounce`) VALUES ('40', 'Как проехать', 'map', 4, 9, 0, 0, 0);

