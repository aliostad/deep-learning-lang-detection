

------------Создание процедуры "flsh_proc_list"------------

DELIMITER $$
DROP PROCEDURE IF EXISTS `flsh_proc_list` $$
CREATE PROCEDURE `flsh_proc_list`(IN `v_component` VARCHAR(50), IN `v_id_object` INT, IN `v_object` VARCHAR(50))
    NO SQL
SELECT fb.*,
       f.title,
       f.url_fla,
       f.url_swf
FROM flsh_flash_bind fb
LEFT JOIN flsh_flash f
ON fb.id_flash = f.id_flash
where (fb.component = v_component) and 
      (fb.id_object = v_id_object) and
      (fb.object = v_object)$$
DELIMITER ;
 

------------Создание процедуры "flsh_proc_view"------------

DELIMITER $$
DROP PROCEDURE IF EXISTS `flsh_proc_view` $$
CREATE PROCEDURE `flsh_proc_view`(IN `v_id_flash` INT)
    NO SQL
SELECT fb.*,
       f.title,
       f.url_fla,
       f.url_swf
FROM flsh_flash_bind fb
LEFT JOIN flsh_flash f
ON fb.id_flash = f.id_flash
where (id_flash_bind = v_id_flash)$$
DELIMITER ;
 
------------------------------------------------------
------------------Начинаются таблицы------------------
------------------------------------------------------

------------Создание таблицы "flsh_flash"------------
CREATE TABLE `flsh_flash` (
  `id_flash` int(11) NOT NULL AUTO_INCREMENT, 
  `title` varchar(255) NOT NULL, 
  `url_fla` varchar(255) NOT NULL, 
  `url_swf` varchar(255) NOT NULL, 
  `order` int(11) NOT NULL, 
  `id_owner` int(11) DEFAULT NULL, 
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `update_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', 
  `id_updater` int(11) NOT NULL, 
  PRIMARY KEY (`id_flash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

------------Создание таблицы "flsh_flash_bind"------------
CREATE TABLE `flsh_flash_bind` (
  `id_flash_bind` int(11) NOT NULL AUTO_INCREMENT, 
  `id_flash` int(11) NOT NULL, 
  `component` varchar(50) NOT NULL, 
  `object` varchar(50) NOT NULL, 
  `id_object` int(11) NOT NULL, 
  `order` int(11) NOT NULL, 
  `id_owner` int(11) NOT NULL, 
  `id_updater` int(11) NOT NULL, 
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `update_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', 
  PRIMARY KEY (`id_flash_bind`), 
  KEY `id_flash` (`id_flash`), 
  KEY `component` (`component`), 
  KEY `object` (`object`), 
  KEY `id_object` (`id_object`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

