use chirokasterlee_;
drop table if exists new_leiding_functie;
drop table if exists new_afbeelding;
drop table if exists new_functies;
drop table if exists new_leiding;
drop table if exists new_nieuws;
drop table if exists new_programmas;
drop table if exists new_kalender;
drop table if exists new_kamp;
drop table if exists new_login;


create table new_leiding (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	chiro char not null,
	naam varchar(100) not null,
	mail varchar(100) not null,
	groep char not null,
	afbeeldingId int not null
) engine=innodb;

create table new_functies (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	omschrijving varchar(100) not null,
	leidingId INT NOT NULL
)engine=innodb;

create table new_nieuws (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	datum date not null,
	bericht varchar(100) not null	
) engine=innodb;

create table new_programmas (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	chiro char not null,
	datum date not null,
	groep char not null,
	programma varchar(100) not null	
) engine=innodb;

create table new_kalender (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	chiro char not null,
	datum date not null,
	activiteit varchar(100) not null	
) engine=innodb;

create table new_kamp (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	chiro char not null,
	tekst varchar(5000) not null	
) engine=innodb;

create table new_login (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	login varchar(20) not null,
	wachtwoord varchar(32) not null,
	chiro char not null
) engine=innodb;

create table new_afbeelding (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type varchar(20) not null,
	data mediumblob not null	
) engine=innodb;

create table new_verhuur (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	chiro char not null,
	tekst varchar(5000) not null	
) engine=innodb;

create table new_chirofeesten (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tekst varchar(5000) not null	
) engine=innodb;

create table new_contact (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tekst varchar(5000) not null	
) engine=innodb;

alter table new_leiding ADD CONSTRAINT fk_1 FOREIGN KEY (afbeeldingId) REFERENCES new_afbeelding (id);
alter table new_leiding_functie ADD CONSTRAINT fk_2 FOREIGN KEY (functieId) REFERENCES new_functies (id);
alter table new_leiding_functie ADD CONSTRAINT fk_3 FOREIGN KEY (leidingId) REFERENCES new_leiding (id);