#!/bin/sh

if [ "$1" = "" ]
then
  echo
  echo "        Usage : $0 <ORACLE_SID>"
  echo
  echo "        Example : $0 tdcsnp"
  echo
  exit
else
  export ORACLE_SID=$1
fi

. /dba/admin/dba.lib

tns=`get_tns_from_orasid $ORACLE_SID`
novausername=novaprd
novauserpwd=`get_user_pwd $tns $novausername`

echo "Starting .............................. "$0

sqlplus -s /nolog << EOF
connect $novausername/$novauserpwd

delete from sga_first_load;
delete from sga_full_schema;
delete from sga_exclude_table;

insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'CM_ADDRESS', sga_first_load_seq.nextval );
insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'CM_CONTACT' , sga_first_load_seq.nextval );
insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'CM_CONTACT_DETAIL', sga_first_load_seq.nextval );

insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'CL_INSURED_LIABILITY', sga_first_load_seq.nextval );
insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'CL_RESERVE_TRANS', sga_first_load_seq.nextval );
insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'PC_ERROR_LOG', sga_first_load_seq.nextval );
insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'PC_INSTALLMENT', sga_first_load_seq.nextval );
insert into sga_first_load( owner, table_name, sort_order ) values( 'NOVAPRD', 'PC_PAYMENT_APPLIED', sga_first_load_seq.nextval );

commit;

--
-- The database trigger to pre load the data cache will only execute on the
-- production database (tdcprd) so now we need to manually execute the
-- process to pre load the data cache.
--
connect / as sysdba
--alter session set events '10949 trace name context forever';
begin
	sga_pre_load.clear_flags;
	sga_pre_load.run_multi_thread( 2 );
end;
/

exit;
EOF

