create table book (
  book_id integer unsigned not null auto_increment primary key,
  title varchar(150) not null,
  notes varchar(512),
  published smallint unsigned default 1,
  owner_status_id integer  unsigned,
  read_status_id integer unsigned,
  type_id integer unsigned,
  last_updated timestamp not null default current_timestamp on update current_timestamp,
  created datetime default null,
  series_num int(10) unsigned default null,
  series_id int(10) unsigned default null,

  foreign key (owner_status_id) references owner_status (owner_status_id),
  foreign key (read_status_id) references read_status (read_status_id),
  foreign key (type_id) references type (type_id),
  foreign key (series_id) references series (series_id)
  
) engine InnoDB;
show warnings;


