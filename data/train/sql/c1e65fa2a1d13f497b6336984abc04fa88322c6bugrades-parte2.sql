-- UPGRADES telas parte 2:

alter table previsions add column observations varchar(256);


alter table plotters add column cuttedBy varchar(64);


alter table plotters add column cuttedTimestamp timestamp ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

update plotters set cuttedTimestamp = '2015-01-01';


--

alter table removedplotters add column cuttedOn date;

alter table removedplotters add column cuttedBy varchar(64);

alter table removedplotters add column cuttedTimestamp timestamp;

--

ALTER TABLE orders DROP PRIMARY KEY;

ALTER TABLE orders ADD number INT NOT NULL AUTO_INCREMENT primary KEY FIRST;

--

UPDATE plotters SET cuttedOn = plotterDate, cuttedBy = 'script-cuttedOn=plotterDate' WHERE cuttedOn is null and cutted=true;

--

insert into usuarios values ('5', 'read', 'read', 'Read only', 'read-only');
insert into usuarios values ('6', 'ordenes', 'ordenes', 'Ordenes', 'ordenes');
insert into usuarios values ('7', 'plotter', 'plotter', 'Plotter', 'plotter');
insert into usuarios values ('8', 'velas-od', 'velas-od', 'Velas OD', 'velas-od');

update roles set role = 'ordenes' where id = 2;

insert into roles values (4, 'velas-od');
insert into roles values (5, 'read-only');

update usuarios set role = 'velas-od' where username = 'ceci';
update usuarios set role = 'read-only' where username = 'claudia';
update usuarios set role = 'read-only' where username = 'fernando';
update usuarios set role = 'read-only' where username = 'juan';
update usuarios set role = 'read-only' where username = 'torkel';
update usuarios set role = 'read-only' where username = 'martin';
update usuarios set role = 'ordenes' where username = 'diego';
update usuarios set role = 'ordenes' where username = 'gonzalo';
update usuarios set role = 'ordenes' where username = 'GUFY';
update usuarios set role = 'ordenes' where username = 'juanpa';
update usuarios set role = 'ordenes' where username = 'lucas';
update usuarios set role = 'ordenes' where username = 'hernan';
update usuarios set role = 'ordenes' where username = 'ismael';

--

create table pctNac (
	value decimal,
	createdOn timestamp
);

insert into pctnac (value) values (45);

--

create table logs (
	type varchar(128),
	log varchar(2048),
	date timestamp
);

-- up to here run in prod
