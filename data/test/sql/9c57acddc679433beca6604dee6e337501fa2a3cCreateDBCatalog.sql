SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /home/courses/w/c/wchenu01/app/ora256/admin/WCHEN/scripts/CreateDBCatalog.log append
@/u01/app/ora256/product/11.2.0.3/CSCIE256/rdbms/admin/catalog.sql;
@/u01/app/ora256/product/11.2.0.3/CSCIE256/rdbms/admin/catblock.sql;
@/u01/app/ora256/product/11.2.0.3/CSCIE256/rdbms/admin/catproc.sql;
@/u01/app/ora256/product/11.2.0.3/CSCIE256/rdbms/admin/catoctk.sql;
@/u01/app/ora256/product/11.2.0.3/CSCIE256/rdbms/admin/owminst.plb;
connect "SYSTEM"/"&&systemPassword"
@/u01/app/ora256/product/11.2.0.3/CSCIE256/sqlplus/admin/pupbld.sql;
connect "SYSTEM"/"&&systemPassword"
set echo on
spool /home/courses/w/c/wchen/admin/WCHEN/scripts/sqlPlusHelp.log append
@/u01/app/ora256/product/11.2.0.3/CSCIE256/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
spool off
