create or replace procedure u1.ETLT_MO_AUTOCHECK_RESULT
     is
       s_mview_name     varchar2(30) := 'T_MO_AUTOCHECK_RESULT';
       vStrDate         date := sysdate;
       v_max_id         number;
      begin
       select /*+ parallel(20) */ max(t.request_id) into v_max_id
        from T_MO_AUTOCHECK_RESULT t;

        insert /*+ APPEND */ into T_MO_AUTOCHECK_RESULT
        select rr.request_id,
               rr.rfo_client_id,
               rr.folder_id,
               rr.verif_id,
               rr.auto_photo_result,
               rr.verif_step,
               rr.system_source,
               rr.status,
               rr.date_create,
               rr.date_send,
               rr.error_msg,
               rr.date_end,
               rr.verif_photo,
               rr.verif_contacts,
               rr.verif_status,
               rr.verif_vector_gr,
               t1.value_number as ap_client_is_reclam_pre ,
               t2.value_number as verif_client_data_is_eq
          from u1.T_AUTOCHECK_RESULT@mo1_prod rr
          left join (select max(t.rfolder_id) as rfolder_id,
                            dp.code_int,
                            t.value_number as folder_id
                       from U1.T_MO_RFOLDER_PAR_VALUE_2016 t
                       join u1.V_MO_D_PAR dp on dp.id = t.d_par_id
                                            and dp.code_int in ('IN_AA_FOLDER_ID')
                      group by dp.code_int, t.value_number
                     )  tt on tt.folder_id = rr.folder_id
          left join U1.T_MO_RFOLDER_PAR_VALUE_2016 t1 on t1.rfolder_id = tt.rfolder_id
                                                     and t1.d_par_id = 2210
          left join U1.T_MO_RFOLDER_PAR_VALUE_2016 t2 on t2.rfolder_id = tt.rfolder_id
                                                     and t2.d_par_id = 2212
       -- left join
        where rr.request_id > v_max_id;
        commit;

 end ETLT_MO_AUTOCHECK_RESULT;
/

