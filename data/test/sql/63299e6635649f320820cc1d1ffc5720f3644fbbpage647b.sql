drop table partitioned;

CREATE TABLE partitioned
( timestamp date,
  id        int
)
PARTITION BY RANGE (timestamp)
(
PARTITION fy_1999 VALUES LESS THAN
( to_date('01-jan-2000','dd-mon-yyyy') ) ,
PARTITION fy_2000 VALUES LESS THAN
( to_date('01-jan-2001','dd-mon-yyyy') ) ,
PARTITION the_rest VALUES LESS THAN
( maxvalue )
)
/

insert /*+ APPEND */ into partitioned partition(fy_1999)
select to_date('31-dec-1999')-mod(rownum,360), object_id
from all_objects
/

commit;

insert /*+ APPEND */ into partitioned partition(fy_2000)
select to_date('31-dec-2000')-mod(rownum,360), object_id
from all_objects
/

commit;

create index partitioned_idx_local
on partitioned(id)
LOCAL
/

create index partitioned_idx_global
on partitioned(timestamp)
GLOBAL
/
