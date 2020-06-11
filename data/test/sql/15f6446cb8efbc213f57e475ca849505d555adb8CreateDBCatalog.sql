SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/CreateDBCatalog.log append
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catalog.sql;
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catblock.sql;
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catproc.sql;
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catoctk.sql;
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/owminst.plb;
connect "SYSTEM"/"&&systemPassword"
@/u01/app/oracle/product/11.2.0/db_1/sqlplus/admin/pupbld.sql;
connect "SYSTEM"/"&&systemPassword"
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/sqlPlusHelp.log append
@/u01/app/oracle/product/11.2.0/db_1/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
spool off
