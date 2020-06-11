sqlplus $SYS_USER/$SYS_PASS@$CONNECT_STRING as sysdba <<EOF >> $CRPSCRIPTS_DIR/logs/commonscriptsUserCreation.log
drop user $PROCESS_SCHEMA_NAME cascade;
create user $PROCESS_SCHEMA_NAME identified by $PROCESS_SCHEMA_PASS default tablespace $PROCESS_SCHEMA_TABLESPACE;
grant resource to $PROCESS_SCHEMA_NAME;
grant connect to $PROCESS_SCHEMA_NAME;
#grant dba to $PROCESS_SCHEMA_NAME;
grant execute on dbms_lock to $PROCESS_SCHEMA_NAME;
grant execute on dbms_utility to $PROCESS_SCHEMA_NAME;
grant execute on DBMS_PIPE to $PROCESS_SCHEMA_NAME;
grant execute on dbms_system to $PROCESS_SCHEMA_NAME;
GRANT SELECT ON V_\$INSTANCE TO $PROCESS_SCHEMA_NAME;
GRANT SELECT ON GV_\$SESSION TO $PROCESS_SCHEMA_NAME;
#GRANT ALTER SYSTEM TO $PROCESS_SCHEMA_NAME;
EOF
