# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table image_model (
  id                        bigint not null,
  image_url                 varchar(255),
  constraint pk_image_model primary key (id))
;

create table tag (
  id                        bigint not null,
  name                      varchar(255),
  value                     varchar(255),
  constraint pk_tag primary key (id))
;


create table tag_image_model (
  tag_id                         bigint not null,
  image_model_id                 bigint not null,
  constraint pk_tag_image_model primary key (tag_id, image_model_id))
;
create sequence image_model_seq;

create sequence tag_seq;




alter table tag_image_model add constraint fk_tag_image_model_tag_01 foreign key (tag_id) references tag (id) on delete restrict on update restrict;

alter table tag_image_model add constraint fk_tag_image_model_image_mode_02 foreign key (image_model_id) references image_model (id) on delete restrict on update restrict;

# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists image_model;

drop table if exists tag_image_model;

drop table if exists tag;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists image_model_seq;

drop sequence if exists tag_seq;

