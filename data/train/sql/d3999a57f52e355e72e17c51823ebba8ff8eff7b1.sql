# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table person_model (
  id                        bigint not null,
  name                      varchar(255),
  constraint pk_person_model primary key (id))
;

create table person_subject_mapping_model (
  person_subject_mapping_id integer not null,
  person_id                 integer,
  subject_id                integer,
  strength_score            float,
  constraint pk_person_subject_mapping_model primary key (person_subject_mapping_id))
;

create table related_keywords_model (
  related_keywords_id       integer not null,
  subject_source_id         integer,
  subject_dest_id           integer,
  strength_score            float,
  constraint pk_related_keywords_model primary key (related_keywords_id))
;

create table subject_model (
  subject_id                integer not null,
  subject_name              varchar(255),
  constraint pk_subject_model primary key (subject_id))
;

create sequence person_model_seq;

create sequence person_subject_mapping_model_seq;

create sequence related_keywords_model_seq;

create sequence subject_model_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists person_model;

drop table if exists person_subject_mapping_model;

drop table if exists related_keywords_model;

drop table if exists subject_model;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists person_model_seq;

drop sequence if exists person_subject_mapping_model_seq;

drop sequence if exists related_keywords_model_seq;

drop sequence if exists subject_model_seq;

