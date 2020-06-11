create or replace procedure u1.ETLT_DWH_DM_CARDSDAILY_HD_T is
      s_mview_name     varchar2(30) := 'DWH_DM_CARDSDAILY_HD_T';
      vStrDate         date := sysdate;
      v_sql            varchar2(1024);
      v_max_date       timestamp;
    begin

      v_sql := 'truncate table DWH_DM_CARDSDAILY_HD_T';

      execute immediate v_sql;

      select max(t.rep_date) into v_max_date
          from DWH_PORT t;

      --update DWH_DM_CARDSDAILY_HD

      insert /*+ append enable_parallel_dml parallel(10)*/ into DWH_DM_CARDSDAILY_HD_T
      select  /*+ parallel(30)*/t.cdhd_rep_date,
              t.cdhd_deal_number,
              t.cdhd_begin_date,
              t.cdhd_set_revolving_date,
              t.cdhd_prod_type,
              t.cdhd_pc_cred,
              t.cdhd_pc_overlimit,
              t.cdhd_pc_overdraft,
              t.cdhd_pc_prc,
              t.cdhd_pc_ovrd_cred,
              t.cdhd_pc_ovrd_overlimit,
              t.cdhd_pc_ovrd_overdraft,
              t.cdhd_pc_ovrd_prc,
              t.cdhd_ovrd_days,
              t.cdhd_pc_vnb_ovrd_cred,
              t.cdhd_pc_vnb_ovrd_overdraft,
              t.cdhd_pc_vnb_ovrd_overlimit,
              t.cdhd_pc_vnb_ovrd_prc_cred
      from DWH_DM_CARDSDAILY_HD_H t
      where t.cdhd_rep_date >= v_max_date
      ;
      commit;


    end ETLT_DWH_DM_CARDSDAILY_HD_T;
/

