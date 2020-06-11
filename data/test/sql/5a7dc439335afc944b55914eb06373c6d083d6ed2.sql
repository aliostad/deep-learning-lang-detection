# --- First database schema
 
# --- !Ups

CREATE SEQUENCE nav_tem_id_seq;
CREATE SEQUENCE ticket_status_id_seq;

CREATE TABLE hd_nav_item (
    id integer NOT NULL DEFAULT nextval('nav_tem_id_seq') primary key,
    group_name varchar(100) not null,
    item varchar(500) not null,
    relative_url varchar(2000) not null,
    group_num INT not null
    
);
 
CREATE TABLE hd_ticket_status (
    id integer NOT NULL DEFAULT nextval('ticket_status_id_seq') primary key,
    name varchar(100) not null
);
 
# --- !Downs
 
DROP TABLE hd_nav_item;
DROP SEQUENCE nav_tem_id_seq;

DROP TABLE hd_ticket_status;
DROP SEQUENCE ticket_status_id_seq;

# --- !Downs
 
