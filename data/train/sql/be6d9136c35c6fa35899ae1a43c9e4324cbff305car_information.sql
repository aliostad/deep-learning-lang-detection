-->Final Project Database<--

CREATE SCHEMA final_project;

SET search_path = final_project, public;

DROP TABLE IF EXISTS new_car_infor;
DROP TABLE IF EXISTS used_car_infor;
DROP TABLE IF EXISTS user_info;
DROP TABLE IF EXISTS user_authentication;
DROP TABLE IF EXISTS adm_info;
DROP TABLE IF EXISTS adm_authentication;
DROP TABLE IF EXISTS log;

CREATE TABLE new_car_infor (
  make char(20) NOT NULL default '',
  model char(20) NOT NULL default '',
  base_price INT NOT NULL  default '0',
  city_MPG INT NOT NULL  default '0',
  Hway_MPG INT NOT NULL  default '0',
  doors INT NOT NULL  default '0',
  engine char(10) NOT NULL default '',
  PRIMARY KEY (model)
);

INSERT INTO new_car_infor VALUES ('Jeep','Wrangler',25995,16,20,4,'Gas');
INSERT INTO new_car_infor VALUES ('Jeep','Compass',18495,21,27,4,'Gas');
INSERT INTO new_car_infor VALUES ('Jeep','Grand Cherokee',28759,17,24,4,'Gas');
INSERT INTO new_car_infor VALUES ('Jeep','Patriot',15995,21,28,4,'Gas');
INSERT INTO new_car_infor VALUES ('Dodge','Avenger',19895,20,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Dodge','Challenger',26295,18,27,2,'Gas');
INSERT INTO new_car_infor VALUES ('Dodge','Charger',26295,19,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Dodge','Durango',29795,16,23,4,'Diesel');
INSERT INTO new_car_infor VALUES ('Dodge','Dart',15995,24,34,4,'Gas');
INSERT INTO new_car_infor VALUES ('KIA','Sorento',24100,20,26,4,'Gas');
INSERT INTO new_car_infor VALUES ('KIA','RIO',13800,28,36,4,'Hybrid');
INSERT INTO new_car_infor VALUES ('KIA','Soul',14700,24,30,4,'Gas');
INSERT INTO new_car_infor VALUES ('Chrysler','200 Series',21195,19,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Chrysler','300 Series',30545,19,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Hyundai','Sonata',21350,22,34,4,'Gas');
INSERT INTO new_car_infor VALUES ('Nissan','XTerra',22940,16,22,4,'Gas');
INSERT INTO new_car_infor VALUES ('Nissan','370Z',33120,18,26,2,'Gas');
INSERT INTO new_car_infor VALUES ('Nissan','Versa',13990,27,36,4,'Gas');
INSERT INTO new_car_infor VALUES ('Nissan','Altima',21860,29,38,4,'Gas');
INSERT INTO new_car_infor VALUES ('Nissan','Maxima',31000,19,26,4,'Gas');
INSERT INTO new_car_infor VALUES ('Nissan','Sentra',15990,27,36,4,'Gas');
INSERT INTO new_car_infor VALUES ('Nissan','Murano',28440,18,24,4,'Gas');
INSERT INTO new_car_infor VALUES ('Ford','C-MAX',25200,40,45,4,'Hybrid');
INSERT INTO new_car_infor VALUES ('Ford','Fiesta',14000,29,39,4,'Gas');
INSERT INTO new_car_infor VALUES ('Ford','Focus',16505,26,36,4,'Gas');
INSERT INTO new_car_infor VALUES ('Ford','Fusion',21900,22,34,4,'Hybrid');
INSERT INTO new_car_infor VALUES ('Ford','Mustang',22200,19,29,2,'Gas');
INSERT INTO new_car_infor VALUES ('Ford','Escape',22700,22,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Ford','Explorer',29600,17,24,4,'Gas');
INSERT INTO new_car_infor VALUES ('Ford','F-150',24070,17,23,2,'Gas');
INSERT INTO new_car_infor VALUES ('Ford','Super Duty',30080,15,18,4,'Diesel');
INSERT INTO new_car_infor VALUES ('Honda','Accord',30200,30,36,4,'Gas');
INSERT INTO new_car_infor VALUES ('Honda','Civic',26650,40,48,4,'Hybrid');
INSERT INTO new_car_infor VALUES ('Honda','CRV',31445,22,30,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','Camry',35185,25,35,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','Corolla',23632,29,38,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','Highlander',49270,17,22,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','Prius',33685,51,48,4,'Hybrid');
INSERT INTO new_car_infor VALUES ('Toyota','Sienna',48324,16,23,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','Venza',40940,20,26,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','4Runner',44952,17,21,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','Prius C',25884,53,46,4,'Hybrid');
INSERT INTO new_car_infor VALUES ('Toyota','Avalon',44849,21,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','RAV4',31640,22,29,4,'Gas');
INSERT INTO new_car_infor VALUES ('Toyota','Prius V',37429,44,40,4,'Hybrid');
INSERT INTO new_car_infor VALUES ('Toyota','Sequoia',65645,13,17,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','A4 Premium Sedan',33800,20,29,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','A6 Premium Sedan',48895,20,29,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','Q7 Quattro',21995,14,19,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','A3',25995,22,28,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','Q5',35950,18,23,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','S5',41890,18,24,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','A5',42380,20,29,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','A7',70065,18,28,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','RS5',79670,16,23,4,'Gas');
INSERT INTO new_car_infor VALUES ('Audi','S6',86395,17,27,4,'Gas');
INSERT INTO new_car_infor VALUES ('BMW','3 Series',49820,23,34,4,'Gas');
INSERT INTO new_car_infor VALUES ('BMW','X1',43245,24,34,4,'Gas');
INSERT INTO new_car_infor VALUES ('BMW','5 Series',65570,21,30,4,'Gas');
INSERT INTO new_car_infor VALUES ('BMW','X3',53095,19,26,4,'Gas');
INSERT INTO new_car_infor VALUES ('BMW','7 Series',91495,19,24,4,'Gas');
INSERT INTO new_car_infor VALUES ('BMW','X5',47500,19,26,4,'Diesel');
INSERT INTO new_car_infor VALUES ('Mercedes Benz','CLA50',33330,22,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Mercedes Benz','C63',62750,13,19,2,'Gas');
INSERT INTO new_car_infor VALUES ('Mercedes Benz','C350',42100,20,29,4,'Gas');
INSERT INTO new_car_infor VALUES ('Mercedes Benz','ML350',66955,18,23,4,'Gas');
INSERT INTO new_car_infor VALUES ('Mercedes Benz','E350',52200,20,28,4,'Gas');
INSERT INTO new_car_infor VALUES ('Mercedes Benz','CLS550',72100,17,25,4,'Gas');
INSERT INTO new_car_infor VALUES ('Mercedes Benz','SLS AMG GT',201500,14,20,2,'Gas');
INSERT INTO new_car_infor VALUES ('Volkswagen','Beetle Convertible',32300,21,29,2,'Gas');
INSERT INTO new_car_infor VALUES ('Volkswagen','CC',33524,22,31,4,'Gas');
INSERT INTO new_car_infor VALUES ('Volkswagen','Eos',35655,22,30,4,'Gas');
INSERT INTO new_car_infor VALUES ('Volkswagen','GLI',25264,24,32,4,'Gas');
INSERT INTO new_car_infor VALUES ('Volkswagen','GTI',31431,24,33,4,'Gas');
INSERT INTO new_car_infor VALUES ('Volkswagen','Jetta Sedan',29158,42,48,4,'Gas');
INSERT INTO new_car_infor VALUES ('Volkswagen','Golf TDI',26253,30,42,4,'Diesel');
INSERT INTO new_car_infor VALUES ('Volkswagen','Passat TDI',25177,31,43,4,'Diesel');


CREATE TABLE used_car_infor (
  car_id SERIAL PRIMARY KEY,
  username char(20) NOT NULL default '' REFERENCES user_info,
  make char(20) NOT NULL default '',
  model char(20) NOT NULL default '',
  price INT NOT NULL  default '0',
  city_MPG INT NOT NULL  default '0',
  Hway_MPG INT NOT NULL  default '0',
  doors INT NOT NULL  default '0',
  engine char(10) NOT NULL default '',
  car_year smallint default NULL,
  status char(100) NOT NULL default '',
  description char(500) NOT NULL default ''
);

CREATE INDEX used_car_infor_car_id_index ON used_car_infor(username);

CREATE TABLE user_infor(
	username 		VARCHAR(30) PRIMARY KEY,
	registration_date 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	description 		VARCHAR(500),
	email 	char(30) NOT NULL default '',
	phone	char(15) NOT NULL default ''
);

CREATE TABLE user_authentication (
	username 	VARCHAR(30) PRIMARY KEY,
	password_hash 	CHAR(40) NOT NULL,
	salt 		CHAR(40) NOT NULL,
	FOREIGN KEY (username) REFERENCES user_infor(username)
);

CREATE TABLE adm_infor (
	adm_name VARCHAR(30) PRIMARY KEY
);

CREATE TABLE adm_authentication (
	adm_name 	VARCHAR(30) PRIMARY KEY,
	password_hash 	CHAR(40) NOT NULL,
	salt 		CHAR(40) NOT NULL,
	FOREIGN KEY (adm_name) REFERENCES adm_infor(adm_name)
);

CREATE TABLE log (
	log_id  	SERIAL PRIMARY KEY,
	username 	VARCHAR(30) NOT NULL REFERENCES user_info,
	ip_address 	VARCHAR(15) NOT NULL,
	log_date 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	action 		VARCHAR(50) NOT NULL
);

CREATE INDEX log_log_id_index ON log (username);



