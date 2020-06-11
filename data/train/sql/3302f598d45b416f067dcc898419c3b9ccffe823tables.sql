create table messages_category (
  category_id serial unique primary key not null,
  display_order integer not null default 0,
  name varchar(50)
);
create table messages (
  message_id serial unique primary key not null,
  category_id integer not null references messages_category(category_id) on delete cascade,  
  read_flag integer not null default 0,
  sender varchar(128) not null,
  receivier varchar(128) not null,
  subject varchar(255) not null,
  body text not null,
  creation_date timestamp not null,
);
--create index messages_id on messages(message_id);
create index messages_cat_id on messages(category_id);
create index messages_receivier on messages(receivier);
create index messages_read_flag on messages(read_flag);
