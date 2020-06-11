create or replace procedure u1.ETLT_PKB_REPORT
      is
      v_last_date date;
      vLast_load_date date;
      vStrDate date := sysdate;
      s_mview_name varchar2(30) := 'T_PKB_REPORT';
      begin
        if to_number(to_char(sysdate,'hh24')) between 0 and 7 then
             v_last_date:=trunc(sysdate); --для ежедневного
          else
            select min(last_date)
            into v_last_date
            from T_RDWH_INCREMENT_TABLES_LOAD
            where object_name in ('T_RFO_Z#KAS_PKB_CI','T_RFO_Z#PKB_REPORT','T_RFO_Z#FDOC','T_RFO_Z#KAS_STRING_250');
            --для онлайн
        end if;

        --Дата последней загрузки
        select last_date
          into vLast_load_date
          from T_RDWH_INCREMENT_TABLES_LOAD tl
         where tl.object_name = s_mview_name;

        delete from T_PKB_REPORT_GT;
        --Собираем id по которым будем удалять
        insert into T_PKB_REPORT_GT
        (
        select /*+ driving_site*/ distinct id
         from s01.s$Z#PKB_REPORT@rdwh_exd
         where src_commit_date >= vLast_load_date
         );

        insert into T_PKB_REPORT_GT
        (
         select /*+ driving_site*/distinct p.id
         from s01.s$Z#KAS_PKB_CI@rdwh_exd  s
         join s01.Z#KAS_PKB_CI@rdwh_exd c on c.id = s.id
         join s01.z#pkb_report@rdwh_exd p on c.collection_id = p.c_ci
                                          or c.collection_id = p.c_closed_ci
         where src_commit_date >= vLast_load_date);

        insert into T_PKB_REPORT_GT
        (
         select /*+ driving_site*/
                distinct p.id
        from s01.s$Z#KAS_STRING_250@rdwh_exd se
        join s01.Z#KAS_STRING_250@rdwh_exd s on  s.id = se.id
        join s01.z#pkb_report@rdwh_exd p on s.collection_id = p.c_agre_statuses
        where src_commit_date >= vLast_load_date);

        insert into T_PKB_REPORT_GT
          (
          select /*+ driving_site*/
                 distinct r.id
          from s01.s$Z#fdoc@rdwh_exd f
          join s01.z#pkb_report@rdwh_exd r on f.id = r.id
          where f.src_commit_date >= vLast_load_date);
        commit;

        delete from T_PKB_REPORT
        where report_id in (select id
                            from T_PKB_REPORT_GT);
        --commit;
         --почистили, теперь заполняем за предыдущие даты.

        --Вставляем
          if to_number(to_char(sysdate,'hh24')) between 0 and 7 then
              insert /*+ append enable_parallel_dml parallel(10)*/
                into T_PKB_REPORT
              (select /*+ parallel(5) */ * from V_PKB_REPORT_GT);
            else
              insert /*+ append*/
                into T_PKB_REPORT
              (select /*+ parallel(30) */ * from V_PKB_REPORT_GT_ONLINE);
          end if;
          commit;


          update t_rdwh_increment_tables_load
             set last_date = v_last_date --trunc(sysdate)
            where object_name = s_mview_name;
          commit;

    end ETLT_PKB_REPORT;
/

