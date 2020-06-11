set timing on
drop table skew3;
set echo on
@flush_pool
create /* compare_insert_merge_ctas.sql */ table skew3 
as select * from skew;
select name, value from v$mystat s, v$statname n
where n.statistic# = s.statistic# and name = 'physical writes direct';

truncate table skew3 drop storage;
INSERT /*+ APPEND */ /* compare_insert_merge_ctas.sql */ 
INTO skew3
select * from skew;
select name, value from v$mystat s, v$statname n
where n.statistic# = s.statistic# and name = 'physical writes direct';

truncate table skew3 drop storage;
MERGE /*+ APPEND */ /* compare_insert_merge_ctas.sql */ 
INTO skew3 t
USING (select * from skew) s
ON (t.pk_col = s.pk_col)
WHEN NOT MATCHED THEN INSERT 
(t.pk_col, t.col1, t.col2, t.col3, t.col4)
     VALUES (s.pk_col, s.col1, s.col2, s.col3, s.col4);
select name, value from v$mystat s, v$statname n
where n.statistic# = s.statistic# and name = 'physical writes direct';
set echo off
