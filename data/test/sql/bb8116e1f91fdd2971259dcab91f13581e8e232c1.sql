# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table app_model (
  dtype                     varchar(10) not null,
  id                        bigint auto_increment not null,
  appname                   varchar(255),
  price                     integer,
  description               varchar(255),
  downurl                   varchar(255),
  author_id                 bigint,
  category_id               bigint,
  app_version               varchar(255),
  app_version_code          varchar(255),
  package_name              varchar(255),
  min_sdk_version           varchar(255),
  target_sdk_version        varchar(255),
  icon_url                  varchar(255),
  downloads                 bigint,
  top_position              bigint,
  delete_flag               tinyint(1) default 0,
  created_at                datetime,
  constraint pk_app_model primary key (id))
;

create table category (
  id                        bigint auto_increment not null,
  name                      varchar(255),
  type                      integer,
  created_at                datetime,
  constraint ck_category_type check (type in (0,1,2)),
  constraint pk_category primary key (id))
;

create table user_model (
  dtype                     varchar(10) not null,
  id                        bigint auto_increment not null,
  name                      varchar(255),
  email                     varchar(255),
  device_id                 varchar(255),
  password                  varchar(255),
  tokenid                   varchar(255),
  token_expiration_time     bigint,
  status                    varchar(8),
  user_role                 varchar(9),
  created_at                datetime,
  constraint ck_user_model_status check (status in ('Active','Inactive')),
  constraint ck_user_model_user_role check (user_role in ('ADMIN','DEVELOPER','USER')),
  constraint pk_user_model primary key (id))
;


create table user_model_app_model (
  user_model_id                  bigint not null,
  app_model_id                   bigint not null,
  constraint pk_user_model_app_model primary key (user_model_id, app_model_id))
;
alter table app_model add constraint fk_app_model_author_1 foreign key (author_id) references user_model (id) on delete restrict on update restrict;
create index ix_app_model_author_1 on app_model (author_id);
alter table app_model add constraint fk_app_model_category_2 foreign key (category_id) references category (id) on delete restrict on update restrict;
create index ix_app_model_category_2 on app_model (category_id);



alter table user_model_app_model add constraint fk_user_model_app_model_user_model_01 foreign key (user_model_id) references user_model (id) on delete restrict on update restrict;

alter table user_model_app_model add constraint fk_user_model_app_model_app_model_02 foreign key (app_model_id) references app_model (id) on delete restrict on update restrict;

# --- !Downs

SET FOREIGN_KEY_CHECKS=0;

drop table app_model;

drop table category;

drop table user_model;

drop table user_model_app_model;

SET FOREIGN_KEY_CHECKS=1;

