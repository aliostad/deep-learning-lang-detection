SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool C:\app\oracle\admin\XXXDBXXX\scripts\postScripts.log append
UPDATE sys.USER$ set SPARE6=NULL;
@C:\app\oracle\product\12.1.0\dbhome_1\rdbms\admin\dbmssml.sql;
@C:\app\oracle\product\12.1.0\dbhome_1\rdbms\admin\dbmsclr.plb;
execute dbms_datapump_utl.replace_default_dir;
commit;
connect "SYS"/"&&sysPassword" as SYSDBA
alter session set current_schema=ORDSYS;
@C:\app\oracle\product\12.1.0\dbhome_1\ord\im\admin\ordlib.sql;
alter session set current_schema=SYS;
connect "SYS"/"&&sysPassword" as SYSDBA
create or replace directory XMLDIR as 'C:\app\oracle\product\12.1.0\dbhome_1\rdbms\xml';
create or replace directory XSDDIR as 'C:\app\oracle\product\12.1.0\dbhome_1\rdbms\xml\schema';
connect "SYS"/"&&sysPassword" as SYSDBA
connect "SYS"/"&&sysPassword" as SYSDBA
execute ORACLE_OCM.MGMT_CONFIG_UTL.create_replace_dir_obj;
execute dbms_qopatch.replace_logscrpt_dirs;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool C:\app\oracle\admin\XXXDBXXX\scripts\postDBCreation.log append
grant sysdg to sysdg;
grant sysbackup to sysbackup;
grant syskm to syskm;
