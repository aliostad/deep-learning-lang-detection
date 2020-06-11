create table big as select * from all_objects;
insert /*+ append */ into big select * from big;
commit;
insert /*+ append */ into big select * from big;
commit;
insert /*+ append */ into big select * from big;
commit;
insert /*+ append */ into big select * from big;
commit;
create index big_idx on big(object_id);


create table small as select * from all_objects where rownum < 100;
create index small_idx on small(object_id);
insert into big select * from small;
commit;

@gen_stats
@gen_stats

rem analyze table big compute statistics
rem for table
rem for all indexes
rem for all indexed columns
rem /
rem analyze table small compute statistics
rem for table
rem for all indexes
rem for all indexed columns
rem /
/*
so, small has 99 rows, big has 133,000+

select count(subobject_name)
  from big
 where object_id in ( select object_id from small )

call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        1      0.01       0.01          0          0          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch        2      0.02       0.02          0        993          0           1
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total        4      0.03       0.03          0        993          0           1

Rows     Execution Plan
-------  ---------------------------------------------------
      0  SELECT STATEMENT   GOAL: CHOOSE
      1   SORT (AGGREGATE)
    792    MERGE JOIN
    100     SORT (JOIN)
    100      VIEW OF 'VW_NSO_1'
     99       SORT (UNIQUE)
    792        INDEX   GOAL: ANALYZED (FULL SCAN) OF 'SMALL_IDX'
                   (NON-UNIQUE)
    891     SORT (JOIN)
      0      TABLE ACCESS   GOAL: ANALYZED (FULL) OF 'BIG'


versus:

select count(subobject_name)
  from big
 where exists ( select null from small where small.object_id = big.object_id )

call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        1      0.00       0.00          0          0          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch        2      4.12       4.12          0     135356         15           1
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total        4      4.12       4.12          0     135356         15           1

Rows     Execution Plan
-------  ---------------------------------------------------
      0  SELECT STATEMENT   GOAL: CHOOSE
      1   SORT (AGGREGATE)
    792    FILTER
 135297     TABLE ACCESS   GOAL: ANALYZED (FULL) OF 'BIG'
 133504     INDEX   GOAL: ANALYZED (RANGE SCAN) OF 'SMALL_IDX'
                (NON-UNIQUE)

That shows if the outer query is "big" and the inner query is "small", in is generally more 
efficient then NOT EXISTS.

Now:

select count(subobject_name)
  from small
 where object_id in ( select object_id from big )

call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        1      0.01       0.01          0          0          0           0
Execute      2      0.00       0.00          0          0          0           0
Fetch        2      0.51       0.82         50        298         22           1
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total        5      0.52       0.83         50        298         22           1



Rows     Execution Plan
-------  ---------------------------------------------------
      0  SELECT STATEMENT   GOAL: CHOOSE
      1   SORT (AGGREGATE)
     99    MERGE JOIN
  16913     SORT (JOIN)
  16912      VIEW OF 'VW_NSO_1'
  16912       SORT (UNIQUE)
 135296        INDEX   GOAL: ANALYZED (FAST FULL SCAN) OF 'BIG_IDX'
                   (NON-UNIQUE)
     99     SORT (JOIN)
     99      TABLE ACCESS   GOAL: ANALYZED (FULL) OF 'SMALL'


versus:
select count(subobject_name)
  from small
 where exists ( select null from big where small.object_id = big.object_id )

call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        1      0.00       0.00          0          0          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch        2      0.01       0.01          0        204         12           1
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total        4      0.01       0.01          0        204         12           1

EGATE)
     99    FILTER
    100     TABLE ACCESS   GOAL: ANALYZED (FULL) OF 'SMALL'
     99     INDEX   GOAL: ANALYZED (RANGE SCAN) OF 'BIG_IDX' (NON-UNIQUE)

*/
