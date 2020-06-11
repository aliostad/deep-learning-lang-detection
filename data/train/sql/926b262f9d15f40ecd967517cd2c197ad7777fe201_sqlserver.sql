USE master
GO
CREATE DATABASE os_demo
GO
ALTER DATABASE os_demo SET READ_COMMITTED_SNAPSHOT ON
GO
CREATE LOGIN os_test WITH PASSWORD='os_password', DEFAULT_DATABASE=os_demo, 
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE os_demo
GO
CREATE USER os_test
GO
ALTER ROLE db_datareader ADD MEMBER os_test
GO
ALTER ROLE db_ddladmin ADD MEMBER os_test
GO

create table refresh_test
(id int not null primary key,
 fname varchar(100) not null,
 lname varchar(200) not null);

create table append_test
(id int not null primary key,
 fname varchar(100) not null,
 lname varchar(200) not null,
 url text);

create table replication_test
(id int not null primary key,
 fname varchar(100) not null,
 lname varchar(200) not null,
 salary float);

insert into refresh_test values (1, 'Jon', 'Roberts');
insert into refresh_test values (2, 'Steve', 'Kerr');
insert into refresh_test values (3, 'Barack', 'Obama');
insert into refresh_test values (4, 'Tom', 'Hanks');
insert into refresh_test values (5, 'Bubba', 'Gump');


insert into append_test values (1, 'Jon', 'Roberts', 'http://www.greenplum.com');
insert into append_test values (2, 'Steve', 'Kerr', 'http://www.espn.com');
insert into append_test values (3, 'Barack', 'Obama', 'http://www.cnn.com');
insert into append_test values (4, 'Tom', 'Hanks', 'http://www.imdb.com');
insert into append_test values (5, 'Bubba', 'Gump', 'http://www.forest.com');

insert into replication_test values (1, 'Jon', 'Roberts', 25.50);
insert into replication_test values (2, 'Steve', 'Kerr', 100);
insert into replication_test values (3, 'Barack', 'Obama', 100);
insert into replication_test values (4, 'Tom', 'Hanks', 250);
insert into replication_test values (5, 'Bubba', 'Gump', 20000);

