# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table email_model (
  id                            bigint not null,
  constraint pk_email_model primary key (id)
);
create sequence email_model_seq;

create table password_model (
  id                            bigint not null,
  constraint pk_password_model primary key (id)
);
create sequence password_model_seq;

create table tags_model (
  id                            bigint not null,
  constraint pk_tags_model primary key (id)
);
create sequence tags_model_seq;

create table tarea_model (
  id                            bigint not null,
  constraint pk_tarea_model primary key (id)
);
create sequence tarea_model_seq;

create table usuario_model (
  id                            bigint not null,
  nombre                        varchar(255),
  edad                          integer,
  constraint pk_usuario_model primary key (id)
);
create sequence usuario_model_seq;


# --- !Downs

drop table if exists email_model;
drop sequence if exists email_model_seq;

drop table if exists password_model;
drop sequence if exists password_model_seq;

drop table if exists tags_model;
drop sequence if exists tags_model_seq;

drop table if exists tarea_model;
drop sequence if exists tarea_model_seq;

drop table if exists usuario_model;
drop sequence if exists usuario_model_seq;

