/*
	Still missing user's pantry and shopping cart.
*/
create table users (
	uid SERIAL,
	uname varchar(20),
	email varchar(40),
	password varchar(25),
	bio text,
	picture text, -- file name, append suffix+extension (nameLarge.png)
	primary key (uid),
	unique(email)
	);

/*
	several ways to store allergens:
		- single varchar[0,1,1,0,1], where each entry corresponds to an allergen (probably not)
		- BOOL entry for each allergen

		- nutrition estimates. May want to store in a joint table, rather than holding empty 

*/
create table recipes(
	rid SERIAL,
	name varchar(75),
	ingredients text ARRAY,
	instructions text,
	totaltime int,
	servings int,
	flavor_piquant real DEFAULT 0,
	flavor_bitter real DEFAULT 0,
	flavor_sweet real DEFAULT 0,
	flavor_meaty real DEFAULT 0,
	flavor_salty real DEFAULT 0,
	flavor_sour real DEFAULT 0,
	rating real DEFAULT 2.5,
	rating_count int DEFAULT 1,
	imagename text,
	calories int,
	uid int DEFAULT 1,
	imagenamesmall text,
	unique(name),
	primary key (rid),
	foreign key(uid) references users
	);

create table usrecipes(
	uid int,
	rid int,
	foreign key(uid) references users,
	foreign key(rid) references recipes,
	unique(rid)
	);

create table favrecipes(
	uid int,
	rid int,
	foreign key(uid) references users,
	foreign key(rid) references recipes
	);

create table blogs(
	eid SERIAL,
	uid int,
	title varchar(75),
	time timestamp,
	extract text,
	foreign key(uid) references users,
	primary key(eid)
	);

