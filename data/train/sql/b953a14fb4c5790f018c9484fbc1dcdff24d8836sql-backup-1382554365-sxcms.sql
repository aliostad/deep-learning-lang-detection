CREATE TABLE IF NOT EXISTS `categorys` (
`id` int(30) NOT NULL AUTO_INCREMENT,
`parent_id` int(30) NOT NULL,
`title` string NOT NULL,
`url` string NOT NULL,
`description` string NOT NULL,
`meta_keywords` string NOT NULL,
`meta_description` string NOT NULL,
`position` int(30) NOT NULL,
`date` int(12) NOT NULL,
`update` int(12) NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `categorys` (`id`, `parent_id`, `title`, `url`, `description`, `meta_keywords`, `meta_description`, `position`, `date`, `update`) VALUES 
('25', '0','Проекты','proekty','Список проектов','','','0','1377266956','1377266956'),
('27', '25','Подкатегория','podkategoriia','фывфыв','','','0','1377568940','1377568940');


CREATE TABLE IF NOT EXISTS `menus` (
`id` int(30) NOT NULL AUTO_INCREMENT,
`title` string NOT NULL,
`name` string NOT NULL,
`description` string NOT NULL,
`template` string NOT NULL,
`date` int(13) NOT NULL,
`update` int(13) NOT NULL,
`class` string NOT NULL,
`parent_class` string NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `menus` (`id`, `title`, `name`, `description`, `template`, `date`, `update`, `class`, `parent_class`) VALUES 
('4', 'Левое меню','left_menu','Меню выводиться слева','','1377261858','1377261858','nav nav-list sidebar','nav nav-list'),
('5', 'Верхнее меню','top_menu','Верхнее меню','','1377261979','1377261979','nav nav-pills pull-right','dropdown-menu');


CREATE TABLE IF NOT EXISTS `links` (
`id` int(30) NOT NULL AUTO_INCREMENT,
`menu_id` int(30) NOT NULL,
`icons` string NOT NULL,
`title` string NOT NULL,
`hidden` int(1) NOT NULL,
`parent_id` int(30) NOT NULL,
`description` string NOT NULL,
`data` string NOT NULL,
`date` int(13) NOT NULL,
`classes` string NOT NULL,
`position` int(31) NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `links` (`id`, `menu_id`, `icons`, `title`, `hidden`, `parent_id`, `description`, `data`, `date`, `classes`, `position`) VALUES 
('22', '4','icon-book','Wiki','0','0','Wiki page','a:5:{s:4:"type";s:1:"4";s:5:"first";s:1:"0";s:6:"second";i:0;s:6:"threed";s:24:"http://wiki.sxservice.ru";s:3:"url";s:24:"http://wiki.sxservice.ru";}','1377292181','','1'),
('21', '4','icon-pencil','Контакты','0','0','','a:4:{s:4:"type";s:1:"2";s:5:"first";s:1:"0";s:6:"second";s:8:"contacts";s:3:"url";s:8:"contacts";}','1377267597','','2'),
('20', '4','icon-home','Главная','0','0','','a:4:{s:4:"type";s:1:"3";s:5:"first";s:1:"/";s:6:"second";i:0;s:3:"url";s:1:"/";}','1377267516','','0'),
('19', '5','','Главная','0','0','Ссылка на главную страницу','a:4:{s:4:"type";s:1:"3";s:5:"first";s:1:"/";s:6:"second";i:0;s:3:"url";s:1:"/";}','1377262024','','0'),
('23', '4','','Проекты','0','0','','a:5:{s:4:"type";s:1:"4";s:5:"first";i:0;s:6:"second";i:0;s:6:"threed";s:0:"";s:3:"url";s:0:"";}','1377470882','nav-header','5'),
('24', '4','icon-shopping-cart','Демо магазина','0','0','','a:5:{s:4:"type";s:1:"4";s:5:"first";i:0;s:6:"second";i:0;s:6:"threed";s:24:"http://shop.sxservice.ru";s:3:"url";s:24:"http://shop.sxservice.ru";}','1377471524','','4'),
('25', '4','','Демо','0','0','','a:5:{s:4:"type";s:1:"4";s:5:"first";s:1:"0";s:6:"second";i:0;s:6:"threed";s:0:"";s:3:"url";s:0:"";}','1377471429','nav-header','3'),
('26', '4','','Модуль магазина','0','23','','a:5:{s:4:"type";s:1:"2";s:5:"first";s:2:"25";s:6:"second";s:22:"proekty/modul-magazina";s:6:"threed";s:0:"";s:3:"url";s:22:"proekty/modul-magazina";}','1377472108','','6'),
('27', '4','','SX cms','0','23','','a:5:{s:4:"type";s:1:"2";s:5:"first";s:2:"25";s:6:"second";s:14:"proekty/sx-cms";s:6:"threed";s:0:"";s:3:"url";s:14:"proekty/sx-cms";}','1377472656','','7');


CREATE TABLE IF NOT EXISTS `pages` (
`id` int(30) NOT NULL AUTO_INCREMENT,
`title` string NOT NULL,
`short_text` string NOT NULL,
`text` string NOT NULL,
`url` string NOT NULL,
`cat_url` string NOT NULL,
`category` int(30) NOT NULL,
`meta_keywords` string NOT NULL,
`meta_description` string NOT NULL,
`template` int(200) NOT NULL,
`author` int(100) NOT NULL,
`status` int(2) NOT NULL,
`position` int(30) NOT NULL,
`date` int(12) NOT NULL,
`update` int(12) NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `pages` (`id`, `title`, `short_text`, `text`, `url`, `cat_url`, `category`, `meta_keywords`, `meta_description`, `template`, `author`, `status`, `position`, `date`, `update`) VALUES 
('1', 'Главная страница SxService','','Главная страница сайта, Проверка','/','','0','SxSerivce, myshop','SxSerivce, myshop наши разработки','0','1','1','1','1375938309','1375938309'),
('3', 'Контакты','','Наши контакты','contacts','','0','Наши контакты, sxservice','Наши контакты','0','1','1','3','1375963447','1375963447'),
('12', 'Sx Cms','Описание CMS','Полное описание CMS','sx-cms','proekty/','25','','','0','0','1','0','1377472013','1377472013'),
('11', 'Модуль магазина','Описание модуля магазина','Полное описание модуля магазина','modul-magazina','proekty/','25','','','0','0','1','0','1377471823','1377471823');


CREATE TABLE IF NOT EXISTS `roles` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`title` string NOT NULL,
`name` string NOT NULL,
`access` string NOT NULL,
`description` string NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `roles` (`id`, `title`, `name`, `access`, `description`) VALUES 
('1', 'Пользователь','login','a:23:{i:0;s:2:"11";i:1;s:2:"12";i:2;s:2:"13";i:3;s:2:"14";i:4;s:2:"21";i:5;s:2:"22";i:6;s:2:"23";i:7;s:2:"24";i:8;s:2:"31";i:9;s:2:"32";i:10;s:2:"33";i:11;s:2:"34";i:12;s:2:"41";i:13;s:2:"42";i:14;s:2:"43";i:15;s:2:"44";i:16;s:2:"51";i:17;s:2:"52";i:18;s:2:"53";i:19;s:2:"54";i:20;s:2:"61";i:21;s:2:"62";i:22;s:2:"63";}','Login privileges, granted after account confirmation'),
('2', 'Администратор','admin','a:23:{i:0;s:2:"11";i:1;s:2:"12";i:2;s:2:"13";i:3;s:2:"14";i:4;s:2:"21";i:5;s:2:"22";i:6;s:2:"23";i:7;s:2:"24";i:8;s:2:"31";i:9;s:2:"32";i:10;s:2:"33";i:11;s:2:"34";i:12;s:2:"41";i:13;s:2:"42";i:14;s:2:"43";i:15;s:2:"44";i:16;s:2:"51";i:17;s:2:"52";i:18;s:2:"53";i:19;s:2:"54";i:20;s:2:"61";i:21;s:2:"62";i:22;s:2:"63";}','Administrative user, has access to everything.'),
('3', 'фыв134123','admin113','','human access granted Wat?'),
('4', 'watt','watt','a:18:{i:0;s:2:"11";i:1;s:2:"12";i:2;s:2:"13";i:3;s:2:"21";i:4;s:2:"22";i:5;s:2:"23";i:6;s:2:"31";i:7;s:2:"32";i:8;s:2:"33";i:9;s:2:"41";i:10;s:2:"42";i:11;s:2:"43";i:12;s:2:"51";i:13;s:2:"52";i:14;s:2:"53";i:15;s:2:"61";i:16;s:2:"62";i:17;s:2:"63";}','asdasd ');


CREATE TABLE IF NOT EXISTS `userroles` (
`user_id` int(10) NOT NULL,
`role_id` int(10) NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `userroles` (`user_id`, `role_id`) VALUES 
('1', '1'),
('5', '1'),
('1', '2'),
('4', '3');


CREATE TABLE IF NOT EXISTS `settings` (
`general` string NOT NULL,
`seo` string NOT NULL,
`template` string NOT NULL,
`cloud` string NOT NULL,
`other` string NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `settings` (`general`, `seo`, `template`, `cloud`, `other`) VALUES 
('a:4:{s:9:"site_name";s:10:"Testo name";s:12:"disable_site";i:0;s:8:"language";s:3:"rus";s:11:"text_editor";s:7:"tinyMce";}', 'a:3:{s:9:"site_name";s:13:"Seo site name";s:11:"description";s:15:"Seo description";s:8:"keywords";s:12:"Seo keywords";}','33','44','');


CREATE TABLE IF NOT EXISTS `users` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`email` string NOT NULL DEFAULT '123123',
`username` string NOT NULL,
`password` string NOT NULL,
`logins` int(10) NOT NULL DEFAULT '0',
`last_login` int(10) NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `users` (`id`, `email`, `username`, `password`, `logins`, `last_login`) VALUES 
('1', 'zeloras@gmail.com','zeloras','310d25472fc0cdfb73860c67c017f66b9fb5122a235f4f836731de5d0f8d9eba','14','1382448257'),
('4', '123@123.ru','123123','8620dce148f5391134170e143257c8eb3206b816c85d3f47415f1484620dd716','0',''),
('5', 'zelo@mail.ro','Паша','8620dce148f5391134170e143257c8eb3206b816c85d3f47415f1484620dd716','0','');


CREATE TABLE IF NOT EXISTS `usertokens` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`user_id` int(11) NOT NULL,
`user_agent` string NOT NULL,
`token` string NOT NULL,
`type` string NOT NULL,
`created` int(10) NOT NULL,
`expires` int(10) NOT NULL,

) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

INSERT INTO `usertokens` (`id`, `user_id`, `user_agent`, `token`, `type`, `created`, `expires`) VALUES 
('2', '1','7218834eb338ee5d85a7faf0443cad8c2fcf1cec','35b5ca1251b80a02e897269086aa0c7105f39f14','','1376238525','1377448125'),
('3', '1','7218834eb338ee5d85a7faf0443cad8c2fcf1cec','c2b4d8b56a2cba6f6112604521845690aefca300','','1376398119','1377607719'),
('4', '1','22883afce154822365dae1b4ba4d0e46fd3156e7','3362529953c8f0f562fb661c2291384a1f400523','','1377261314','1378470914'),
('5', '1','b92b4daf636153ca4fdb2d5cf8320f46d338e595','b614753c1f54b7dc2eaef6fbb920c716861df724','','1379820188','1381029788');


