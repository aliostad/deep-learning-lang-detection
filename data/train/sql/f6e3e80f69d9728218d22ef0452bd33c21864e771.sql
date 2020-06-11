# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table email_user_model (
  email                     varchar(255) not null,
  password                  varchar(255),
  salt                      varchar(255),
  user_id                   bigint,
  email_confirm             boolean,
  constraint pk_email_user_model primary key (email))
;

create table page_model (
  url                       varchar(255) not null,
  last_update               timestamp not null,
  constraint pk_page_model primary key (url))
;

create table role_model (
  id                        varchar(255) not null,
  title                     varchar(255),
  description               TEXT,
  last_update               timestamp not null,
  constraint pk_role_model primary key (id))
;

create table system_property_model (
  name                      varchar(255) not null,
  value                     varchar(255),
  description               TEXT,
  last_update               timestamp not null,
  constraint pk_system_property_model primary key (name))
;

create table user_model (
  id                        bigint not null,
  name                      varchar(255),
  surname                   varchar(255),
  birth_date                timestamp,
  phone                     varchar(255),
  gender                    boolean,
  is_active                 boolean,
  last_update               timestamp not null,
  constraint pk_user_model primary key (id))
;


create table page_model_role_model (
  page_model_url                 varchar(255) not null,
  role_model_id                  varchar(255) not null,
  constraint pk_page_model_role_model primary key (page_model_url, role_model_id))
;

create table user_model_role_model (
  user_model_id                  bigint not null,
  role_model_id                  varchar(255) not null,
  constraint pk_user_model_role_model primary key (user_model_id, role_model_id))
;
create sequence email_user_model_seq;

create sequence page_model_seq;

create sequence role_model_seq;

create sequence system_property_model_seq;

create sequence user_model_seq;

alter table email_user_model add constraint fk_email_user_model_user_1 foreign key (user_id) references user_model (id);
create index ix_email_user_model_user_1 on email_user_model (user_id);



alter table page_model_role_model add constraint fk_page_model_role_model_page_01 foreign key (page_model_url) references page_model (url);

alter table page_model_role_model add constraint fk_page_model_role_model_role_02 foreign key (role_model_id) references role_model (id);

alter table user_model_role_model add constraint fk_user_model_role_model_user_01 foreign key (user_model_id) references user_model (id);

alter table user_model_role_model add constraint fk_user_model_role_model_role_02 foreign key (role_model_id) references role_model (id);

# --- !Downs

drop table if exists email_user_model cascade;

drop table if exists page_model cascade;

drop table if exists page_model_role_model cascade;

drop table if exists role_model cascade;

drop table if exists system_property_model cascade;

drop table if exists user_model cascade;

drop table if exists user_model_role_model cascade;

drop sequence if exists email_user_model_seq;

drop sequence if exists page_model_seq;

drop sequence if exists role_model_seq;

drop sequence if exists system_property_model_seq;

drop sequence if exists user_model_seq;

