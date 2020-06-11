drop DATABASE IF EXISTS customer;
create database customer;
drop table if exists customer.address;
drop table if exists customer.customer;
create table customer.address (address_id integer not null, streetName varchar(50), primary key (address_id));
create table customer.customer (customer_id integer not null, address_id integer, customer_name varchar(50), primary key (customer_id));
alter table customer.customer add index FK24217FDE275A68F4 (address_id), add constraint FK24217FDE275A68F4 foreign key (address_id) references customer.address (address_id);
