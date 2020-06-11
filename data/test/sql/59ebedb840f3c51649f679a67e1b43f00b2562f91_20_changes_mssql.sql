-- changes to CFMBB 1.20 from 1.1/1.11

alter table dbo.cfmbb_settings add defaultIndex varchar(35) not null default 'forums.cfm';
alter table dbo.cfmbb_settings add enableChat smallint not null default 1;
alter table dbo.cfmbb_settings add useCaptcha smallint not null default 1;
alter table dbo.cfmbb_threads add views integer not null default 0;
alter table dbo.cfmbb_forums add lastpost text null;
alter table dbo.cfmbb_forums add msgcount integer not null default 0;
alter table dbo.cfmbb_threads add msgcount integer not null default 0;
alter table dbo.cfmbb_threads add lastpost datetime not null default (getdate());

CREATE TABLE [dbo].[cfmbb_notifications]
(
	[useridfk] varchar(35) not null,
	[idfk] varchar(35) not null default '',
	[notification_type] smallint not null,
	primary key (useridfk, idfk)
)

CREATE TABLE [dbo].[cfmbb_pages] 
(
	PAGE_ID char(35) not null,
	PAGE_FILENAME varchar(255) NOT NULL,
	PAGE_TITLE varchar(255) NOT NULL,
	META_DESC text NOT NULL,
	META_KEYS text NOT NULL,
	CONTENT_ID varchar(35) NOT NULL,
	INCLUDE_CONTENT varchar(255) null,
	REDIRECT_URL varchar(255) null,
	MEMBERS_ONLY smallint not null default '0',
	PRIMARY KEY  (PAGE_ID)
);

CREATE TABLE [dbo].[cfmbb_page_content] 
(
	CONTENT_ID varchar(35) NOT NULL default '',
	HISTORY_ID bigint not null,
	HISTORY_DATE datetime NOT NULL,
	CONTENT mediumtext NULL,
	PRIMARY KEY  (CONTENT_ID,HISTORY_ID)
);

CREATE TABLE [dbo].[cfmbb_custom_nav] 
(
	nav_id char(35) NOT NULL,
	nav_order smallint(6) NOT NULL default '0',
	page_id char(35) default NULL,
	nav_url varchar(255) default NULL,
	nav_title varchar(255) default NULL,
	target varchar(255) default NULL,
	PRIMARY KEY  (nav_id)
);
	

CREATE TABLE [dbo].[cfmbb_usergroups]
(
	id char(35) not null,
	title varchar(255) not null,
	description text null,
	primary key (id)
);

CREATE TABLE [dbo].[cfmbb_usergroup_members]
(
	groupidfk char(35) not null,
	useridfk char(35) not null,
	primary key (groupidfk, useridfk)
);


CREATE TABLE [dbo].[chat_rooms] 
(
        room_id int not null IDENTITY(1,1),
        room_name nvarchar(30) not null DEFAULT '',
        permanent int not null default 0,
        allow_rename int not null default 0,
        allow_private int not null default 0,
        primary key (room_id)
);

create unique index idxRoomName on dbo.chat_rooms(room_name);

SET IDENTITY_INSERT chat_rooms ON;
insert into chat_rooms
( room_id, room_name, permanent, allow_rename, allow_private )
values
(1, 'Lobby', 1, 0, 0);

CREATE TABLE [dbo].[chat_users] (
        user_id nchar(35) not null,
        uname nvarchar(30) not null,
        primary key (user_id)
);


CREATE TABLE [dbo].[room_users] (
        room_id int not null,
        user_id nchar(35) not null,
        uname nvarchar(30) not null,
        pingtime datetime not null,
        active smallint not null default 0,
        primary key (room_id, user_id)
);

CREATE TABLE [dbo].[chat_content] (
  line_id int NOT NULL IDENTITY(1,1),
  room_id int not null,
  action int not null,
  user_id nchar(35) not null,
  uname nvarchar(30) NOT NULL default '',
  content ntext not null,
  recip_id nchar(35) not null default '',
  tstamp bigint null,
  PRIMARY KEY  (line_id)
);