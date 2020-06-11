# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table dumb_model (
  id                        bigint auto_increment not null,
  text                      varchar(255),
  constraint pk_dumb_model primary key (id))
;

create table dumb_relation_model (
  id                        bigint auto_increment not null,
  value                     varchar(255),
  constraint pk_dumb_relation_model primary key (id))
;


create table dumb_model_dumb_relation_model (
  dumb_model_id                  bigint not null,
  dumb_relation_model_id         bigint not null,
  constraint pk_dumb_model_dumb_relation_model primary key (dumb_model_id, dumb_relation_model_id))
;



alter table dumb_model_dumb_relation_model add constraint fk_dumb_model_dumb_relation_model_dumb_model_01 foreign key (dumb_model_id) references dumb_model (id) on delete restrict on update restrict;

alter table dumb_model_dumb_relation_model add constraint fk_dumb_model_dumb_relation_model_dumb_relation_model_02 foreign key (dumb_relation_model_id) references dumb_relation_model (id) on delete restrict on update restrict;

# --- !Downs

SET FOREIGN_KEY_CHECKS=0;

drop table dumb_model;

drop table dumb_model_dumb_relation_model;

drop table dumb_relation_model;

SET FOREIGN_KEY_CHECKS=1;

