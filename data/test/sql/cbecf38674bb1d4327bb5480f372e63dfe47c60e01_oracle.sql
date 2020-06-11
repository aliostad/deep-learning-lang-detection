create user os_test identified by os_password;
grant dba to os_test;

create table os_test.append_test
(id int not null primary key,
 fname varchar2(100) not null,
 lname varchar2(200) not null,
 url clob);

create table os_test.replication_test
(id int not null primary key,
 fname varchar2(100) not null,
 lname varchar2(200) not null,
 salary number);


insert into os_test.append_test values (1, 'Jon', 'Roberts', 'http://www.greenplum.com');
insert into os_test.append_test values (2, 'Steve', 'Kerr', 'http://www.espn.com');
insert into os_test.append_test values (3, 'Barack', 'Obama', 'http://www.cnn.com');
insert into os_test.append_test values (4, 'Tom', 'Hanks', 'http://www.imdb.com');
insert into os_test.append_test values (5, 'Bubba', 'Gump', 'http://www.forest.com');

insert into os_test.replication_test values (1, 'Jon', 'Roberts', 25.50);
insert into os_test.replication_test values (2, 'Steve', 'Kerr', 100);
insert into os_test.replication_test values (3, 'Barack', 'Obama', 100);
insert into os_test.replication_test values (4, 'Tom', 'Hanks', 250);
insert into os_test.replication_test values (5, 'Bubba', 'Gump', 20000);
commit;

