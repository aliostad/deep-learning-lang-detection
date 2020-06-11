spool local_schema_setup.log append
set echo on

REMARK	Changing database properties (e.g. characterset) to match production database

connect system/system as sysdba

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER SYSTEM ENABLE RESTRICTED SESSION;
ALTER SYSTEM SET JOB_QUEUE_PROCESSES=0;
ALTER SYSTEM SET AQ_TM_PROCESSES=0;
ALTER DATABASE OPEN;
ALTER DATABASE CHARACTER SET INTERNAL_USE AL32UTF8;
SHUTDOWN;
STARTUP RESTRICT;
SHUTDOWN;
STARTUP; 

REMARK	Changing few system properties to scale better

ALTER SYSTEM SET open_cursors = 5000 SCOPE=MEMORY;
ALTER SYSTEM SET open_cursors = 5000 SCOPE=SPFILE;
ALTER SYSTEM SET session_cached_cursors = 50 SCOPE=SPFILE;
ALTER SYSTEM SET recyclebin=off;

spool off
exit;