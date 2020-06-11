use b2b;
set names utf8;

drop table if exists company_nav;
create table company_nav(
    id mediumint(8) unsigned not null auto_increment primary key,
    corpid mediumint(8) unsigned not null  ,
    name varchar(20) not null default '链接',
    urltype tinyint(4) unsigned not null default 0,
    url   varchar(200) not null default '',
    target varchar(10) not null default '_self',
    key(corpid)
)engine=myisam default charset=utf8 collate=utf8_general_ci;

drop table if exists company_nav2;
create table company_nav2(
    id mediumint(8) unsigned not null auto_increment primary key,
    corpid mediumint(8) unsigned not null  ,
    name varchar(20) not null default '链接',
    urltype tinyint(4) unsigned not null default 0,
    url   varchar(200) not null default '',
    target varchar(10) not null default '_self',
    key(corpid)
)engine=myisam default charset=utf8 collate=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `urltarget` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

insert into urltarget(name) values
('_self'),
('_blank');

