select count(*) from asup.ddfs_info_1067737310331548
select * from asup.ddfs_info_1067737310331548 limit 1

select count(*) from asup.ddfs_info where sn='1FZ0934017'

select distinct 

select * from asup.geninfo where sn='1FZ0934017'

select * from asup.sub where sn='1FZ0934017'

select * from pg_stat_activity


CREATE EXTERNAL TABLE asup.ddfs_info_test_13( asupid numeric, sn character varying ,ts  character varying ,msg text ) Location('gpfdist://10.25.192.33:8080/DDFS_INFO_1058258531906548') FORMAT 'text' (delimiter '|' )
CREATE EXTERNAL TABLE asup.ddfs_info_test_14( asupid numeric, sn character varying ,ts  character varying ,msg text ) Location('gpfdist://10.25.192.33:8080/DDFS_INFO_1058263858546548') FORMAT 'text' (delimiter '|' );
--143086 
--1951635  
--54574

INSERT INTO asup.ddfs_info (asupid,sn,ts,msg)
select newTable.asupid,newTable.sn,newTable.ts,newTable.msg
FROM asup.ddfs_info_test_14 newTable
WHERE NOT EXISTS
        (SELECT NULL
         FROM asup.ddfs_info oldTable
         WHERE newTable.sn = oldTable.sn
             AND newTable.msg=oldTable.msg) 


--1931822 
--107792 
--61263 
INSERT INTO asup.ddfs_info (asupid,sn,ts,msg)
select newTable.asupid,newTable.sn,newTable.ts,newTable.msg
FROM asup.ddfs_info_test_13 newTable
WHERE NOT EXISTS
        (SELECT NULL
         FROM asup.ddfs_info oldTable
         WHERE newTable.sn = '1FZ0934017'
             AND newTable.msg=oldTable.msg) 


select * from asup.sub where  