/*
	Still missing user's pantry and shopping cart.
*/
create table users (
	uid SERIAL,
	uname varchar(20),
	email varchar(40),
	password varchar(25),
	bio text,
	picture varchar(25), -- file name, append suffix+extension (nameLarge.png)
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
	-- set DEFAULT 0, or not??? later replace null values with 0
	name varchar(75),
	ingredients text ARRAY,
	instructions text,
	totalTime int,
	servings int,
	flavor_piquant real DEFAULT 0,
	flavor_bitter real DEFAULT 0,
	flavor_sweet real DEFAULT 0,
	flavor_meaty real DEFAULT 0,
	flavor_salty real DEFAULT 0,
	flavor_sour real DEFAULT 0,
	rating real DEFAULT 2.5,	-- consider changing to real or float to average rating over time, then round on return
	-- consider keeping a ratings field, used to calculate changes in rating.
	imageName varchar(25), 	--consider several methods - uniquename+suffix+extension, uid+rid+suffix+extension
	unique(imageName),
	primary key (rid)

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

