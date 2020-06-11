# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table contact_model (
  contact_id                integer not null,
  name                      varchar(65),
  phone                     varchar(255),
  constraint pk_contact_model primary key (contact_id))
;

create sequence contact_model_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists contact_model;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists contact_model_seq;

