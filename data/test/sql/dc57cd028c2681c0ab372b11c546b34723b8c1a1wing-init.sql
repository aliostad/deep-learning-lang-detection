--
-- Initialise WING tables.
-- Must be run as the httpd user.
--

drop index sessions_username_ix;
drop table sessions;

create table sessions (
    id		char(24) not null primary key,	-- session id
    start	timestamp not null,		-- when session was started
    username	char(8) not null,		-- username
    host	varchar(15) not null,		-- dotted-quad peer IP address
    server	varchar(64) not null,		-- hostname of server
    pid		integer				-- PID of server session daemon
);
create unique index sessions_username_ix on sessions (username);

drop table abook_ids;
create table abook_ids (
	id		serial,
	username	char(8) not null,
	tag		text not null,
	primary key (username, tag)
);

drop table abook_perms;
create table abook_perms (
	id	integer	not null,
	type	char not null,
	name	char(8) not null,
	primary key(id, type, name)
);

drop table abook_aliases;
create table abook_aliases (
	id		integer	not null,
	alias		text not null,
	first_name	text not null,
	last_name	text not null,
	comment		text not null,
	email		text not null,
	primary key (id, alias)
);

drop table options;

create table options (
	username	char(8)	not null primary key,
	signature	text,		-- mail sig to append
	abooklist	text,		-- default address book search list
	composeheaders	text,		-- default headers for compose screen
	listsize	integer,	-- default lines per screen for list
	copyoutgoing	bool		-- copy outgoing mail to sent-mail
);

grant all on options to httpd;
grant all on options to root;
grant select on options to public;
