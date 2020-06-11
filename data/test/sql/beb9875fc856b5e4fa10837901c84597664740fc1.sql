# --- !Ups

create table company_model (
  id                        bigint not null,
  name                      varchar(255),
  description               varchar(255),
  marquee                   varchar(255),
  created_at                timestamp,
  constraint pk_company_model primary key (id))
;

create table content_model (
  id                        bigint not null,
  name                      varchar(255),
  description               varchar(255),
  url                       varchar(255),
  phone_number              varchar(255),
  small_pic                 varchar(255),
  big_pic                   varchar(255),
  content_type              integer,
  language                  integer,
  delete_flag               boolean,
  created_at                timestamp,
  constraint ck_content_model_content_type check (content_type in (0,1,2,3,4)),
  constraint ck_content_model_language check (language in (0,1)),
  constraint pk_content_model primary key (id))
;

create table user_model (
  id                        bigint not null,
  name                      varchar(255),
  email                     varchar(255),
  device_id                 varchar(255),
  password                  varchar(255),
  status                    varchar(8),
  user_role                 varchar(9),
  created_at                timestamp,
  constraint ck_user_model_status check (status in ('ACTIVE','INACTIVE')),
  constraint ck_user_model_user_role check (user_role in ('ADMIN','DEVELOPER','USER')),
  constraint pk_user_model primary key (id))
;

create sequence company_model_seq;

create sequence content_model_seq;

create sequence user_model_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists company_model;

drop table if exists content_model;

drop table if exists user_model;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists company_model_seq;

drop sequence if exists content_model_seq;

drop sequence if exists user_model_seq;

