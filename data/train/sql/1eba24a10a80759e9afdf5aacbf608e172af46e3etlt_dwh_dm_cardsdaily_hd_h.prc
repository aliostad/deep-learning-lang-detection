create or replace procedure u1.ETLT_DWH_DM_CARDSDAILY_HD_H is
      s_mview_name     varchar2(30) := 'DWH_DM_CARDSDAILY_HD_H';
      vStrDate         date := sysdate;
      v_max_date2      timestamp;
    begin

      select max(t.cdhd_rep_date)
        into v_max_date2
        from DWH_DM_CARDSDAILY_HD_H t;

      insert /*+ APPEND */ into DWH_DM_CARDSDAILY_HD_H
      select  t.cdhd_rep_date,
              substr(t.cdhd_deal_number,1,250) as cdhd_deal_number,
              t.cdhd_begin_date,
              t.cdhd_set_revolving_date,
              substr(t.cdhd_prod_type,1,255) as cdhd_prod_type,
              t.cdhd_pc_cred,
              t.cdhd_pc_overlimit,
              t.cdhd_pc_overdraft,
              t.cdhd_pc_prc,
              t.cdhd_pc_ovrd_cred,
              t.cdhd_pc_ovrd_overlimit,
              t.cdhd_pc_ovrd_overdraft,
              t.cdhd_pc_ovrd_prc,
              t.cdhd_ovrd_days,
              trunc(sysdate),
              t.cdhd_pc_vnb_ovrd_cred,
              t.cdhd_pc_vnb_ovrd_overdraft,
              t.cdhd_pc_vnb_ovrd_overlimit,
              t.cdhd_pc_vnb_ovrd_prc_cred,
              null, --t.cdhd_restruct_type,
              null --t.cdhd_restruct_count
      from DWH_SAN.DM_CARDSDAILY_HD@DWH_PROD2 t
      where t.cdhd_rep_date >= v_max_date2 + 1
       and (nvl(t.cdhd_pc_cred,0) +
            nvl(t.cdhd_pc_prc,0) +
            nvl(t.cdhd_pc_overlimit,0) +
            nvl(t.cdhd_pc_overdraft,0) +
            nvl(t.cdhd_pc_ovrd_cred,0) +
            nvl(t.cdhd_pc_ovrd_prc,0) +
            nvl(t.cdhd_pc_ovrd_overlimit,0) +
            nvl(t.cdhd_pc_ovrd_overdraft,0)) +
            nvl(t.cdhd_pc_vnb_ovrd_cred,0) +
            nvl(t.cdhd_pc_vnb_ovrd_overdraft,0) +
            nvl(t.cdhd_pc_vnb_ovrd_overlimit,0) +
            nvl(t.cdhd_pc_vnb_ovrd_prc_cred,0) > 0;
      commit;


    end ETLT_DWH_DM_CARDSDAILY_HD_H;
/

