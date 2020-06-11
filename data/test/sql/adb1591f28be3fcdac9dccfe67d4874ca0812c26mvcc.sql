// MVCC: Multi-Version Concurrency Control
   1) READ COMMITTED, REPEATABLE READ

create table User (
    id int(11) unsigned not null auto_increment,
    primary key (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

// insert(事务版本号10)
id      create_version    delete_version
1       10

// update(事务版本号20)
id      create_version    delete_version
1       10                20
1       20

// delete(事务版本号30)
id      create_version    delete_version
1       20                30

// select
   1) create_version小于事务版本号的行
   2) delete_version为空, 或delete_version大于事务版本号的行
