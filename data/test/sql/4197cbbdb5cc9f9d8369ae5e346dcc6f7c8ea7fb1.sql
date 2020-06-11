# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table category_model (
  id                        integer not null,
  name                      varchar(255),
  staff_responsible         integer,
  constraint pk_category_model primary key (id))
;

create table order_model (
  order_id                  integer not null,
  quantity_of_products      integer,
  total_cost                integer,
  profit                    integer,
  date                      varchar(255),
  constraint pk_order_model primary key (order_id))
;

create table product_model (
  id                        integer not null,
  name                      varchar(255),
  description               varchar(255),
  cost                      double,
  rrp                       double,
  quantity                  integer,
  constraint pk_product_model primary key (id))
;

create table user_model (
  id                        integer not null,
  email                     varchar(255),
  password                  varchar(255),
  firstname                 varchar(255),
  lastname                  varchar(255),
  dob                       varchar(255),
  telephone                 varchar(255),
  address1                  varchar(255),
  address2                  varchar(255),
  town                      varchar(255),
  postcode                  varchar(255),
  constraint pk_user_model primary key (id))
;

create sequence category_model_seq;

create sequence order_model_seq;

create sequence product_model_seq;

create sequence user_model_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists category_model;

drop table if exists order_model;

drop table if exists product_model;

drop table if exists user_model;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists category_model_seq;

drop sequence if exists order_model_seq;

drop sequence if exists product_model_seq;

drop sequence if exists user_model_seq;

