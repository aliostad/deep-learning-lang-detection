CREATE OR REPLACE PROCEDURE NCAOWII.SP_COPY_D(P_TABLE varchar2) IS
  v_strsql VARCHAR2(400);
  v_code   NUMBER;
  v_errm   varchar2(1024);
  v_IS_EXIST number := 0;
BEGIN

--every Saturday ,if P_TABLE is  new table,then add record msg into table_control
---by ZhangWJ 2012-02-06

  IF TO_CHAR(SYSDATE+0.2,'D') = 7 THEN   ---如果4.8小时后是周六，则判断是否是新增表,主要是应对23点前就开始运行的表。
    select count(*)
    into v_IS_EXIST
    from naiawii.TABLE_CONTROL a
    where table_name = P_TABLE;
    COMMIT;
  IF v_IS_EXIST = 0 THEN
     v_strsql := ' insert into naiawii.TABLE_CONTROL values ('''||P_TABLE||''',0,0,''Y'',''Y'',''D'',''S'',''S'',NULL,NULL,''4'',NULL,NULL,1000,''NEW_TABLE'')';
     execute immediate v_strsql;
     COMMIT;
  END IF ;
  END IF ;

---cancel the data copy from naiawii to ncaowii by ZhangWJ 2013-04-01 
--
--  v_strsql := 'truncate table ' || P_TABLE;
--  execute immediate v_strsql;
--  v_strsql := 'insert /*+append,parallel(a,16) */ into ' || P_TABLE ||
--              ' a select /*+parallel(t,16)*/ * from naiawii.' || P_TABLE || ' t'
--   ;
--  PRC_PRE_COPY_TABLE(P_TABLE,'U');
--  execute immediate v_strsql;
--  PRC_PRE_COPY_TABLE(P_TABLE,'A');
--  COMMIT;
--
  
  -----update table rownum into table_control@wii01
  update naiawii.TABLE_CONTROL  T
     set TABLE_RECORDS_BEFORE     = TABLE_RECORDS_CURRENT,
         COUNT_STATUS             = 'W',
         COUNT_PROCESS_START_DATE = SYSDATE
   WHERE TABLE_ENABLE = 'Y'
     AND T.TABLE_NAME = P_TABLE;
  commit;
  v_strsql := 'update naiawii.TABLE_CONTROL T set TABLE_RECORDS_CURRENT =(select count(*) from ' ||
              P_TABLE ||
              ') , COUNT_STATUS=''S'',COUNT_PROCESS_END_DATE=SYSDATE  where t.TABLE_ENABLE=''Y''  and table_name=''' ||
              P_TABLE || '''';
  execute immediate v_strsql;
  commit;

exception
  when others then
    v_code := SQLCODE;
    v_errm := SQLERRM;
    rollback;
    insert into naiawii.sp_error_log
    values
      ('SP_COPY_D',
       sysdate,
       v_code,
       v_errm,
       'SP_COPY_D Error, The Sql is : ' || v_strsql);
    commit;

    raise; --Harry[2010-03-23], reraise the exception in order to the linux shell can catch this error
END;
/
