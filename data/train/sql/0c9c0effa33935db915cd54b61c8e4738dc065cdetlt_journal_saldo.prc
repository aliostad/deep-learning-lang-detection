create or replace procedure u1.ETLT_JOURNAL_SALDO is
    v_max_id                number;
    d_max_date_saldo        date;
    d_max_id_saldo          number;
    vStrDate                date := sysdate;
    s_mview_name            varchar2(30) := 'T_RBO_Z#JOURNAL_SALDO';

    d_src_commit_date_last date; --дата последней загруженной строки
    d_src_commit_date_load date; --дата, по которую делаем загрузку
  begin
     select max(src_commit_date)
        into d_src_commit_date_load
        from s02.s$Z#JOURNAL_SALDO@rdwh_exd;

      select last_date-10/24/60/60
        into d_src_commit_date_last
        from T_RDWH_INCREMENT_TABLES_LOAD
       where object_name = 'T_RBO_Z#JOURNAL_SALDO';

     delete from T_RBO_Z#JOURNAL_SALDO
         where id in (select distinct id
                        from s02.s$Z#JOURNAL_SALDO@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);

    insert /*+ APPEND */ into T_RBO_Z#JOURNAL_SALDO
    select t.id,
           t.collection_id,
           t.c_saldo,
           t.c_date,
           t.c_saldo_nt,
           t.c_turn_day_dt,
           t.c_turn_day_dt_nt,
           t.c_turn_day_ct,
           t.c_turn_day_ct_nt
      from rdwh.V_RBO_Z#JOURNAL_SALDO@rdwh_exd t
      where id in (select distinct id
                        from s02.s$Z#JOURNAL_SALDO@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;

    --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = 'T_RBO_Z#JOURNAL_SALDO';
        commit;


  end ETLT_JOURNAL_SALDO;
/

