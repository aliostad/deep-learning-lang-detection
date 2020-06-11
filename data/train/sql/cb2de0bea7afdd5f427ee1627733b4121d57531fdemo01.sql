-- Executing SQLLDR with the EXTERNAL_TABLE Parameter

set echo on

drop table dept purge;

create table dept
  ( deptno  number(2) constraint dept_pk primary key,
    dname   varchar2(14),
    loc     varchar2(13)
)
/

drop table "SYS_SQLLDR_X_EXT_DEPT";

CREATE TABLE "SYS_SQLLDR_X_EXT_DEPT"
(
  "DEPTNO" NUMBER(2),
  "DNAME" VARCHAR2(14),
  "LOC" VARCHAR2(13)
)
ORGANIZATION external
(
  TYPE oracle_loader
  DEFAULT DIRECTORY SYS_SQLLDR_XT_TMPDIR_00000
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    BADFILE 'SYS_SQLLDR_XT_TMPDIR_00000':'demo1.bad'
    LOGFILE 'demo1.log_xt'
    READSIZE 1048576
    SKIP 6
    FIELDS TERMINATED BY "," LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
    (
      "DEPTNO" CHAR(255)
        TERMINATED BY ",",
      "DNAME" CHAR(255)
        TERMINATED BY ",",
      "LOC" CHAR(255)
        TERMINATED BY ","
    )
  )
  location
  (
    'demo1.ctl'
  )
)REJECT LIMIT UNLIMITED
/

INSERT /*+ append */ INTO DEPT
  (
    DEPTNO,
    DNAME,
    LOC
  )
  SELECT
    "DEPTNO",
    "DNAME",
    "LOC"
  FROM "SYS_SQLLDR_X_EXT_DEPT"
/

-- Dealing with Errors

drop table et_bad;

create table et_bad
  ( text1 varchar2(4000) ,
    text2 varchar2(4000) ,
    text3 varchar2(4000)
  )
  organization external
  (type oracle_loader
   default directory SYS_SQLLDR_XT_TMPDIR_00000
   access parameters
   (
     records delimited by newline
     fields
     missing field values are null
     ( text1 position(1:4000),
       text2 position(4001:8000),
       text3 position(8001:12000)
     )
   )
   location ('demo1.bad')
  )
/
