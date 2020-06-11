create or replace procedure u1.ETLT_DWH_DM_SPGU_HD_T is
      s_mview_name     varchar2(30) := 'DWH_DM_SPGU_HD_T';
      vStrDate         date := sysdate;
      v_max_date       timestamp;
      v_sql            varchar2(1024);
    begin

      select max(t.rep_date)
        into v_max_date
        from DWH_PORT t;


      v_sql := 'truncate table DWH_DM_SPGU_HD_T';
      execute immediate v_sql;

        insert /*+ append enable_parallel_dml parallel(10)*/ into DWH_DM_SPGU_HD_T
        select  /*+ parallel(30)*/
                t.exhd_rep_date,
                t.exhd_deal_number,
                t.exhd_begin_date,
                t.exhd_prod_type,
                t.exhd_old_ovd_scheme,
                t.exhd_fgu_cred,
                t.exhd_fgu_prc,
                t.exhd_fgu_ovrd_cred,
                t.exhd_fgu_ovrd_prc,
                t.exhd_ovrd_days,
                t.exhd_vnb_ovrd_cred,
                t.exhd_vnb_ovrd_prc,
                t.exhd_vnb_comm,
                t.exhd_fgu_overdraft,
                t.exhd_fgu_ovrd_overdraft,
                t.exhd_vnb_overdraft
           from DWH_DM_SPGU_HD_H t
          where t.exhd_rep_date >= v_max_date;

          commit;



    end ETLT_DWH_DM_SPGU_HD_T;
/

