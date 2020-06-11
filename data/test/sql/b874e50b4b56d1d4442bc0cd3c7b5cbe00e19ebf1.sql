# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table phone_model (
  id                        bigint not null,
  name                      varchar(255),
  constraint pk_phone_model primary key (id))
;

create table task_model (
  id                        bigint not null,
  label                     varchar(255),
  enabled                   boolean,
  constraint pk_task_model primary key (id))
;

create table user_model (
  id                        bigint not null,
  name                      varchar(255),
  phone_id                  bigint,
  constraint pk_user_model primary key (id))
;

create sequence phone_model_seq;

create sequence task_model_seq;

create sequence user_model_seq;

alter table user_model add constraint fk_user_model_phone_1 foreign key (phone_id) references phone_model (id) on delete restrict on update restrict;
create index ix_user_model_phone_1 on user_model (phone_id);



# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists phone_model;

drop table if exists task_model;

drop table if exists user_model;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists phone_model_seq;

drop sequence if exists task_model_seq;

drop sequence if exists user_model_seq;

