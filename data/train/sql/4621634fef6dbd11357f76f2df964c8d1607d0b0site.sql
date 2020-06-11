/* user */

create table user(
	id int unsigned primary key auto_increment,
	name varchar(20) default '',
	nickname varchar(20) default '',
	anoy_name varchar(20) default '',
	created int unsigned default 0,
	last_login_time int unsigned default 0,
	last_login_ip int unsigned default 0,
	status tinyint default 1
);

create table userinfo(
	uid int unsigned default 0,
	sex tinyint unsigned default 0,
	sex_pub tinyint unsigned default 1,
	birth varchar(10) default '',
	birth_pub tinyint unsigned default 0,
	from_id varchar(10) default '',
	live_id varchar(10) default '',
	married tinyint unsigned default 1,
	married_pub tinyint unsigned default 1,
	job varchar(255) default '',
	sign varchar(255) default '',
	n_bbs_post int unsigned default 0,
	n_bbs_cmt int unsigned default 0,
	n_bbs_mark int unsigned default 0
);

/* bbs */
drop table if exists bbs_post;
create table bbs_post(
	id int unsigned primary key auto_increment,
	nid int default 0 comment '结点id',
	title varchar(255),
	uid int default 0,
	content text,
	ctime int default 0,
	n_mark int default 0,
	n_click int default 0,
	n_cmt int default 0,
	n_like int default 0,
	is_show tinyint default 1,
	status tinyint default 1 comment '1-未审核，0-已审核',
	last_cmt_ctime int unsigned default 0,
	last_cmt_userid int unsigned default 0,
	last_cmt_username varchar(20) default ''
);

drop table if exists bbs_append;
create table bbs_append(
	id int unsigned primary key auto_increment,
	pid int unsigned default 0,
	content text,
	ctime int unsigned default 0,
	is_show tinyint default 1,
	status tinyint default 1 comment '1-未审核，0-已审核'
);

drop table if exists bbs_node;
create table bbs_node(
	id int unsigned primary key auto_increment,
	name varchar(50) default '',
	n_post int unsigned default 0,
	unique name(name)
);

drop table if exists bbs_mark;
create table bbs_mark
(
	uid int unsigned default 0,
	pid int unsigned default 0,
	ctime int unsigned default 0,
	unique uni(uid, pid)
);

drop table if exists bbs_like;
create table bbs_like
(
	uid int unsigned default 0,
	pid int unsigned default 0,
	ctime int unsigned default 0,
	unique uni(uid, pid)
);

drop table if exists bbs_cmt;
create table bbs_cmt(
	id int unsigned primary key auto_increment,
	pid int unsigned default 0,
	uid int unsigned default 0,
	content text,
	n_like int unsigned default 0,
	ctime int unsigned default 0,
	is_show tinyint default 1,
	status tinyint default 1
);

drop table if exists bbs_cmt_like;
create table bbs_cmt_like
(
	uid int unsigned default 0,
	cid int unsigned default 0,
	ctime int unsigned default 0,
	unique uni(uid, pid)
);

drop table if exists bbs_notice;
create table bbs_notice(
	id int unsigned primary key auto_increment,
	suid int unsigned default 0,
	ruid int unsigned default 0,
	pid int unsigned default 0,
	cid int unsigned default 0,
	ctime int unsigned default 0,
	has_read tinyint unsigned default 0
);

/* site */
drop table if exists site_setting;
create table site_setting(
	k varchar(20) default '',
	v varchar(255) default '',
	unique k(k) 
);

drop table if exists site_city;
create table site_city(
	sid tinyint unsigned default 0,
	cid tinyint unsigned default 0,
	rid tinyint unsigned default 0,
	tid tinyint unsigned default 0,
	name varchar(50) default ''
);