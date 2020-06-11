insert /*+ APPEND */
into FACT_ORDER_LINE_P
select * from FACT_ORDER_LINE;
commit;

select segment_name,sum(bytes)/power(2,20) mb
from user_segments
group by segment_name --1542
order by mb desc;

alter table FACT_ORDER_LINE move;

insert /*+ APPEND */
into FACT_ORDER_LINE_ATT_P
select t.*,to_date(lpad(order_date_key,8,'0'),'DDMMYYYY') sdt
from FACT_ORDER_LINE_ATT t;

select segment_name,partition_name,tablespace_name,extents,bytes/power(2,20) mb
  from user_segments 
  --where segment_name in ('FACT_ORDER_LINE_ATT_P','DIM_ATTRIBUTES')
--  and partition_name='SYS_P501'
  order by mb desc;
  
  alter table FACT_ORDER_LINE_ATT_P move partition sys_p501 tablespace users;
  
  create table bob
  tablespace users
  pctfree 0 compress nologging
  as
  select * from FACT_ORDER_LINE_ATT_P partition (SYS_P501);
  