# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table book_comment_model (
  id                        varchar(255) not null,
  author_id                 varchar(255),
  posted_at                 timestamp,
  content                   varchar(255),
  book_page_id              integer,
  constraint pk_book_comment_model primary key (id))
;

create table book_list (
  id                        varchar(255) not null,
  book_name                 varchar(255),
  book_id                   varchar(255),
  owner_id                  varchar(255),
  constraint pk_book_list primary key (id))
;

create table book_model (
  id                        varchar(255) not null,
  title                     varchar(255),
  author                    varchar(255),
  isbn                      varchar(255),
  constraint pk_book_model primary key (id))
;

create table comment_model (
  id                        varchar(255) not null,
  author_id                 varchar(255),
  posted_at                 timestamp,
  content                   varchar(255),
  constraint pk_comment_model primary key (id))
;

create table followee_model (
  id                        varchar(255) not null,
  username                  varchar(255),
  user_id                   varchar(255),
  owner_id                  varchar(255),
  constraint pk_followee_model primary key (id))
;

create table following_list_model (
  id                        integer not null,
  constraint pk_following_list_model primary key (id))
;

create table trade_model (
  sender_id                 varchar(255) not null,
  time_of_trade             timestamp,
  constraint pk_trade_model primary key (sender_id))
;

create table trade_record_model (
  id                        varchar(255) not null,
  sender_id                 varchar(255),
  receiver                  varchar(255),
  book_sent                 varchar(255),
  book_received             varchar(255),
  time_of_trade             timestamp,
  constraint pk_trade_record_model primary key (id))
;

create table user_comment_model (
  id                        varchar(255) not null,
  author_id                 varchar(255),
  posted_at                 timestamp,
  content                   varchar(255),
  user_page_id              integer,
  constraint pk_user_comment_model primary key (id))
;

create table user_model (
  id                        varchar(255) not null,
  username                  varchar(255),
  password                  varchar(255),
  repeat_password           varchar(255),
  constraint pk_user_model primary key (id))
;

create sequence book_comment_model_seq;

create sequence book_list_seq;

create sequence book_model_seq;

create sequence comment_model_seq;

create sequence followee_model_seq;

create sequence following_list_model_seq;

create sequence trade_model_seq;

create sequence trade_record_model_seq;

create sequence user_comment_model_seq;

create sequence user_model_seq;

alter table book_comment_model add constraint fk_book_comment_model_author_1 foreign key (author_id) references user_model (id) on delete restrict on update restrict;
create index ix_book_comment_model_author_1 on book_comment_model (author_id);
alter table comment_model add constraint fk_comment_model_author_2 foreign key (author_id) references user_model (id) on delete restrict on update restrict;
create index ix_comment_model_author_2 on comment_model (author_id);
alter table user_comment_model add constraint fk_user_comment_model_author_3 foreign key (author_id) references user_model (id) on delete restrict on update restrict;
create index ix_user_comment_model_author_3 on user_comment_model (author_id);



# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists book_comment_model;

drop table if exists book_list;

drop table if exists book_model;

drop table if exists comment_model;

drop table if exists followee_model;

drop table if exists following_list_model;

drop table if exists trade_model;

drop table if exists trade_record_model;

drop table if exists user_comment_model;

drop table if exists user_model;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists book_comment_model_seq;

drop sequence if exists book_list_seq;

drop sequence if exists book_model_seq;

drop sequence if exists comment_model_seq;

drop sequence if exists followee_model_seq;

drop sequence if exists following_list_model_seq;

drop sequence if exists trade_model_seq;

drop sequence if exists trade_record_model_seq;

drop sequence if exists user_comment_model_seq;

drop sequence if exists user_model_seq;

