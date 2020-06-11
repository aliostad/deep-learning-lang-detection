prompt Show file, block, row numbers from rowid &1....

def rowid=&1

select
    dbms_rowid.ROWID_RELATIVE_FNO('&rowid') rfile#
  , dbms_rowid.ROWID_BLOCK_NUMBER('&rowid') block#
  , dbms_rowid.ROWID_ROW_NUMBER('&rowid')   row#
  , lpad('0x'||trim(to_char(dbms_utility.MAKE_DATA_BLOCK_ADDRESS(dbms_rowid.ROWID_RELATIVE_FNO('&rowid')
  , dbms_rowid.ROWID_BLOCK_NUMBER('&rowid')), 'XXXXXXXX')), 10) rowid_dba
  , 'alter system dump datafile '||dbms_rowid.ROWID_RELATIVE_FNO('&rowid')||' block '||
                                   dbms_rowid.ROWID_BLOCK_NUMBER('&rowid')||'; -- @dump '||
                                   dbms_rowid.ROWID_RELATIVE_FNO('&rowid')||' '||
                                   dbms_rowid.ROWID_BLOCK_NUMBER('&rowid')||' .' dump_command
from
    dual
/
