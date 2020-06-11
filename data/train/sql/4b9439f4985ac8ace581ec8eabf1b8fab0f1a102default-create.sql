create table customer (
  id                        bigint auto_increment not null,
  first_name                varchar(255),
  last_name                 varchar(255),
  constraint pk_customer primary key (id))
;

create table customer_email (
  id                        bigint auto_increment not null,
  customer_id               bigint,
  email                     varchar(255),
  constraint pk_customer_email primary key (id))
;

create table customer_phone (
  id                        bigint auto_increment not null,
  customer_id               bigint,
  phone_number              varchar(255),
  constraint pk_customer_phone primary key (id))
;

alter table customer_email add constraint fk_customer_email_customer_1 foreign key (customer_id) references customer (id) on delete restrict on update restrict;
create index ix_customer_email_customer_1 on customer_email (customer_id);
alter table customer_phone add constraint fk_customer_phone_customer_2 foreign key (customer_id) references customer (id) on delete restrict on update restrict;
create index ix_customer_phone_customer_2 on customer_phone (customer_id);


