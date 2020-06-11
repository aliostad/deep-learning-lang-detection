create or replace procedure u1.ETLT_OUT_DWH_QUESTION is
      s_mview_name     varchar2(30) := 'T_OUT_DWH_QUESTION';
      vStrDate         date := sysdate;
      n_max_question_id number;

    begin
      select max(id)
        into n_max_question_id
        from T_OUT_DWH_QUESTION;

      execute immediate 'truncate table T_OUT_DWH_QUESTION_VERIFICATOR';
      execute immediate
      'insert into T_OUT_DWH_QUESTION_VERIFICATOR
      Select id,
             code,
             name,
             text,
             schema_id,
             portition_date
        from verificator.OUT_DWH_QUESTION@verifais
       where id > '||n_max_question_id;
      commit;

      execute immediate 'truncate table T_OUT_DWH_QUESTION_PRE';


      insert /*+ append */into T_OUT_DWH_QUESTION_PRE
      select /*+ parallel(20)*/
             q.id,
             q.code,
             q.name,
             dbms_lob.substr(q.text, 4000, 1),
             q.schema_id,
             q.portition_date
        from T_OUT_DWH_QUESTION_VERIFICATOR q;
      commit;

      insert /*+ append*/into T_OUT_DWH_QUESTION
      select /*+ parallel(20)*/
             q.id,
             q.code,
             q.name,
             (select listagg(replace( replace(regexp_substr(q.text,'>.*?<', 1,rownum), '>', ''),'<','')) within group (order by rownum)  a
                from dual
             connect by rownum <= regexp_count(q.text,'>.*?<')),
             q.schema_id,
             q.portition_date
        from T_OUT_DWH_QUESTION_PRE q;
      commit;

   end ETLT_OUT_DWH_QUESTION;
/

