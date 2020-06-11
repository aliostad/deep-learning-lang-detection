create or replace procedure u1.ETLT_RBO_PAYMENT_CARD is
       s_mview_name     varchar2(30) := 'T_RBO_PAYMENT_CARD';
       vStrDate         date := sysdate;
       n_fo_id_max      number;
       e_user_exception exception;
     begin
       --определяем последнюю загруженную проводку
       select max(fo_id)
         into n_fo_id_max
         from T_RBO_PAYMENT_CARD;

       insert /*+ append parallel(20)*/into T_RBO_PAYMENT_CARD
                     (rbo_contract_id,contract_number,oper_payment_code,oper_payment_name,oper_date,amount,
                      fo_id,reverse_fo,is_storno)
      select kpd.id,
             kpd.c_num_dog,
             vod.c_code,
             vod.sys_name,
             fo.c_doc_date,
             fo.c_summa,
             fo.id,
             fo.c_reverse_fo,
             fo.c_is_storno
        from u1.V_RBO_Z#VID_OPER_DOG vod
        join u1.T_RBO_Z#KAS_PC_FO     fo on fo.c_vid_oper_ref = vod.id
        join u1.V_RBO_Z#KAS_PC_DOG   kpd on kpd.c_fo_arr = fo.collection_id
       where vod.c_code in ('PC_TO_CARD_KASSA_TR',
                            'PC_TO_CARD_KASSA',
                            'PC_TO_CARD_ATM',
                            'PC_TO_CARD_FROM_KAZPOST',
                            'PC_TO_CARD_FROM_ACASH',
                            'PC_TO_CARD_FROM_ACASH_EXT',
                            'PC_TO_CARD_FROM_ZP')
         and fo.c_doc_state = 'PROV'
         and fo.id > n_fo_id_max;
        commit;



    end ETLT_RBO_PAYMENT_CARD;
/

