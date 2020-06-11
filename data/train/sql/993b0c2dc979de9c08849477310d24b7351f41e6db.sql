create database oozie default character set utf8;
create database hive default character set utf8;
create database cm default character set utf8;
create database rman default character set utf8;
create database nav default character set utf8;
create database nava default character set utf8;
create database navm default character set utf8;
create database amon default character set utf8;
create database hue default character set utf8;

grant all privileges on hue.* to 'hue'@'localhost' identified by 'hue';
grant all privileges on hue.* to 'hue'@'%' identified by 'hue';

grant all privileges on amon.* to 'amon'@'localhost' identified by 'amon';
grant all privileges on amon.* to 'amon'@'%' identified by 'amon';

grant all privileges on nava.* to 'nava'@'localhost' identified by 'nava';
grant all privileges on nava.* to 'nava'@'%' identified by 'nava';

grant all privileges on oozie.* to 'oozie'@'localhost' identified by 'oozie';
grant all privileges on hive.* to 'hive'@'localhost' identified by 'hive';
grant all privileges on rman.* to 'rman'@'localhost' identified by 'rman'; 
grant all privileges on cm.* to 'cm'@'localhost' identified by 'cm';
grant all privileges on nav.* to 'nav'@'localhost' identified by 'nav';
grant all privileges on navm.* to 'navm'@'localhost' identified by 'navm';

grant all privileges on oozie.* to 'oozie'@'%' identified by 'oozie';
grant all privileges on hive.* to 'hive'@'%' identified by 'hive';
grant all privileges on rman.* to 'rman'@'%' identified by 'rman'; 
grant all privileges on cm.* to 'cm'@'%' identified by 'cm'; 
grant all privileges on nav.* to 'nav'@'%' identified by 'nav';
grant all privileges on navm.* to 'navm'@'%' identified by 'navm';
