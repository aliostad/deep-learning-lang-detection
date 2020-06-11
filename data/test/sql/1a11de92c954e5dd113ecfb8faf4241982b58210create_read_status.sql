-- must include '--local-infile=1' after | lbd when using a csv. This gives permission to use a local file.

drop table if exists read_status;

create table read_status (
        read_status_id   integer unsigned    not null auto_increment primary key,
        status            varchar(150)        not null,
        last_updated      timestamp           not null default current_timestamp on update current_timestamp,
        created           datetime            not null
) engine InnoDB;

load data local infile 'data/read_status.csv' into table read_status
fields terminated by ',' optionally enclosed by '"' ignore 1 lines;

select * from read_status;