SET ECHO ON
SET VERIFY OFF

connect "SYS"/"change_me" as SYSDBA
startup nomount;

spool /tmp/orainstall/dbcreation.log append

CREATE DATABASE edie
   USER SYS IDENTIFIED BY change_me
   USER SYSTEM IDENTIFIED BY change_me
   MAXLOGHISTORY 1
   MAXLOGFILES 16
   MAXLOGMEMBERS 3
   MAXDATAFILES 1024
   CHARACTER SET AL32UTF8
   NATIONAL CHARACTER SET AL16UTF16
   EXTENT MANAGEMENT LOCAL
   DATAFILE '/u01/app/oracle/oradata/edie/system01.dbf'
     SIZE 700M REUSE AUTOEXTEND ON NEXT 10240K MAXSIZE UNLIMITED
   SYSAUX DATAFILE '/u01/app/oracle/oradata/edie/sysaux01.dbf'
     SIZE 550M REUSE AUTOEXTEND ON NEXT 10240K MAXSIZE UNLIMITED
   DEFAULT TABLESPACE users
      DATAFILE '/u01/app/oracle/oradata/edie/users01.dbf'
      SIZE 500M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED
   DEFAULT TEMPORARY TABLESPACE tempts1
      TEMPFILE '/u01/app/oracle/oradata/edie/temp01.dbf'
      SIZE 20M REUSE AUTOEXTEND ON NEXT 640K MAXSIZE UNLIMITED
   UNDO TABLESPACE undotbs1
      DATAFILE '/u01/app/oracle/oradata/edie/undotbs01.dbf'
      SIZE 200M REUSE AUTOEXTEND ON NEXT 5120K MAXSIZE UNLIMITED
   USER_DATA TABLESPACE usertbs
      DATAFILE '/u01/app/oracle/oradata/edie/usertbs01.dbf'
      SIZE 200M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED
   LOGFILE GROUP 1 ('/u01/logs/redo01a.log','/u01/logs/redo01b.log') SIZE 100M,
           GROUP 2 ('/u01/logs/redo02a.log','/u01/logs/redo02b.log') SIZE 100M,
           GROUP 3 ('/u01/logs/redo03a.log','/u01/logs/redo03b.log') SIZE 100M;

