insert into os_test.append_test values (6, 'Jon', 'Roberts', 'http://www.greenplum.com');
insert into os_test.append_test values (7, 'Steve', 'Kerr', 'http://www.espn.com');
insert into os_test.append_test values (8, 'Barack', 'Obama', 'http://www.cnn.com');
insert into os_test.append_test values (9, 'Tom', 'Hanks', 'http://www.imdb.com');
insert into os_test.append_test values (10, 'Bubba', 'Gump', 'http://www.forest.com');

update os_test.replication_test set salary = salary*2;
delete from os_test.replication_test where id = 1;

commit;