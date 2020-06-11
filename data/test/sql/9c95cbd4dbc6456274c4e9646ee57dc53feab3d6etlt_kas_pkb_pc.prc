create or replace procedure u1.ETLT_KAS_PKB_PC is
    s_mview_name varchar2(30) := 'T_RFO_Z#KAS_PKB_PC';
    vStrDate date := sysdate;
    n_id_max number;
    begin
     select max(id)
       into n_id_max
       from T_RFO_Z#KAS_PKB_PC;

     insert /*+ append enable_parallel_dml parallel(10)*/into T_RFO_Z#KAS_PKB_PC
     select /*+ parallel(20)*/ c.id,c.c_payment_title,c.c_payment_overdue,c.collection_id,c.sn,c.su,
     case when length(c.c_payment_title) in (4,5) then
               to_date('01-'||lpad(substr(c.c_payment_title,1,instr(c.c_payment_title,'/')-1),2,'0')||'-20'||substr(c.c_payment_title,instr(c.c_payment_title,'/')+1,length(c.c_payment_title)) ,'dd-mm-yyyy')
          when length(c.c_payment_title) > 5 then
               to_date('01-'||lpad(substr(c.c_payment_title,1,instr(c.c_payment_title,'/')-1),2,'0')||substr(c.c_payment_title,instr(c.c_payment_title,'/')+1,length(c.c_payment_title)),'dd-mm-yyyy')
      end as c_payment_date
     from IBS.Z#KAS_PKB_PC@RFO_SNAP c
     where c.c_payment_overdue is not null and c.c_payment_overdue != '-'
     and c.id > n_id_max;
     commit;
end ETLT_KAS_PKB_PC;
/

