connect 'C:\Users\Bocman\Documents\Database\Hotel.fdb' user 'SYSDBA' password 'masterkey';


set transaction snapshot;


select * from for_trans;

insert into for_trans values(4,'grysha',56);


insert into for_trans values(5,'klybnika',14);

delete from for_trans where id =4;

delete from for_trans where id =5;




set transaction SNAPSHOT TABLE STABILITY; 


set transaction READ COMMITTED 	NO RECORD_VERSION WAIT;

set transaction READ COMMITTED 	NO RECORD_VERSION NO WAIT;

set transaction READ COMMITTED 	NO RECORD_VERSION ;

set transaction READ COMMITTED RECORD_VERSION ;