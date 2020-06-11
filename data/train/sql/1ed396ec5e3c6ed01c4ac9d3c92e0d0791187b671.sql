# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table book (
  id                        bigint not null,
  isbn                      varchar(255),
  title                     varchar(255),
  authors                   varchar(255),
  description               TEXT,
  isbn_10                   varchar(255),
  page_count                integer,
  average_rating            integer,
  ratings_count             integer,
  publisher                 varchar(255),
  published_date            timestamp,
  thumbnail                 varchar(255),
  constraint pk_book primary key (id))
;

create table current_read (
  id                        bigint not null,
  start_date                timestamp,
  current_thoughts          varchar(255),
  rmember_id                bigint,
  book_id                   bigint,
  constraint pk_current_read primary key (id))
;

create table desired_read (
  id                        bigint not null,
  start_date                timestamp,
  current_thoughts          varchar(255),
  rmember_id                bigint,
  book_id                   bigint,
  constraint pk_desired_read primary key (id))
;

create table finished_read (
  id                        bigint not null,
  start_date                timestamp,
  current_thoughts          varchar(255),
  rmember_id                bigint,
  book_id                   bigint,
  finish_date               timestamp,
  constraint pk_finished_read primary key (id))
;

create table rmember (
  id                        bigint not null,
  username                  varchar(255),
  email_address             varchar(255),
  facebook_token            varchar(255),
  constraint pk_rmember primary key (id))
;

create table read (
  id                        bigint not null,
  start_date                timestamp,
  current_thoughts          varchar(255),
  rmember_id                bigint,
  book_id                   bigint,
  constraint pk_read primary key (id))
;


create table friends (
  rmember_my                     bigint not null,
  rmember_of                     bigint not null,
  constraint pk_friends primary key (rmember_my, rmember_of))
;
create sequence book_seq;

create sequence current_read_seq;

create sequence desired_read_seq;

create sequence finished_read_seq;

create sequence rmember_seq;

create sequence read_seq;

alter table current_read add constraint fk_current_read_rmember_1 foreign key (rmember_id) references rmember (id);
create index ix_current_read_rmember_1 on current_read (rmember_id);
alter table current_read add constraint fk_current_read_book_2 foreign key (book_id) references book (id);
create index ix_current_read_book_2 on current_read (book_id);
alter table desired_read add constraint fk_desired_read_rmember_3 foreign key (rmember_id) references rmember (id);
create index ix_desired_read_rmember_3 on desired_read (rmember_id);
alter table desired_read add constraint fk_desired_read_book_4 foreign key (book_id) references book (id);
create index ix_desired_read_book_4 on desired_read (book_id);
alter table finished_read add constraint fk_finished_read_rmember_5 foreign key (rmember_id) references rmember (id);
create index ix_finished_read_rmember_5 on finished_read (rmember_id);
alter table finished_read add constraint fk_finished_read_book_6 foreign key (book_id) references book (id);
create index ix_finished_read_book_6 on finished_read (book_id);
alter table read add constraint fk_read_rmember_7 foreign key (rmember_id) references rmember (id);
create index ix_read_rmember_7 on read (rmember_id);
alter table read add constraint fk_read_book_8 foreign key (book_id) references book (id);
create index ix_read_book_8 on read (book_id);



alter table friends add constraint fk_friends_rmember_01 foreign key (rmember_my) references rmember (id);

alter table friends add constraint fk_friends_rmember_02 foreign key (rmember_of) references rmember (id);

# --- !Downs

drop table if exists book cascade;

drop table if exists current_read cascade;

drop table if exists desired_read cascade;

drop table if exists finished_read cascade;

drop table if exists rmember cascade;

drop table if exists friends cascade;

drop table if exists read cascade;

drop sequence if exists book_seq;

drop sequence if exists current_read_seq;

drop sequence if exists desired_read_seq;

drop sequence if exists finished_read_seq;

drop sequence if exists rmember_seq;

drop sequence if exists read_seq;

