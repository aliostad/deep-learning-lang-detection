--Extent Trimming with UNIFORM vs. AUTOALLOCATE Locally-Managed Tablespaces

drop tablespace lmt_auto including contents and datafiles;
drop tablespace lmt_uniform including contents and datafiles;

create tablespace lmt_uniform
datafile '/u01/dbfile/ORA12CR1/lmt_uniform.dbf' size 1048640K reuse
autoextend on next 100m
extent management local
UNIFORM SIZE 100m;

create tablespace lmt_auto
datafile '/u01/dbfile/ORA12CR1/lmt_auto.dbf' size 1048640K reuse
autoextend on next 100m
extent management local
AUTOALLOCATE;

create table uniform_test
  parallel
  tablespace lmt_uniform
  as
  select * from big_table_et;

create table autoallocate_test
  parallel
  tablespace lmt_auto
  as
  select * from big_table_et;

select sid, serial#, qcsid, qcserial#, degree from v$px_session;

column segment_name format a20

select segment_name, blocks, extents
  from user_segments
  where segment_name in ( 'UNIFORM_TEST', 'AUTOALLOCATE_TEST' );

exec show_space( 'UNIFORM_TEST' );
exec show_space( 'AUTOALLOCATE_TEST' );

select segment_name, extent_id, blocks
from user_extents where segment_name = 'UNIFORM_TEST';

select segment_name, blocks, count(*)
from user_extents
where segment_name = 'AUTOALLOCATE_TEST'
group by segment_name, blocks
order by blocks;

alter session enable parallel dml;

insert /*+ append */ into UNIFORM_TEST 
select * from big_table_et;
 
insert /*+ append */ into AUTOALLOCATE_TEST 
select * from big_table_et;

commit;

exec show_space( 'UNIFORM_TEST' );
exec show_space( 'AUTOALLOCATE_TEST' );
