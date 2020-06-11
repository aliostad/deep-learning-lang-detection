-- File Locations 

set echo on

show parameter dump_dest

select name, value
    from v$parameter
    where name like  '%dump_dest%';

select name, value
   from v$parameter
   where name like  '%dump_dest%';

set serveroutput on
exec dbms_output.put_line( scott.get_param( 'user_dump_dest' ) )

column name format a22
column value format a40
with home
  as
  (select value home
     from v$diag_info
    where name = 'ADR Home'
  )
  select name,
         case when value <> home.home
                  then replace(value,home.home,'$home$')
                          else value
              end value
    from v$diag_info, home
/

column trace new_val TRACE format a100

select c.value || '/' || d.instance_name || '_ora_' || a.spid || '.trc' trace
    from v$process a, v$session b, v$parameter c, v$instance d
   where a.addr = b.paddr
     and b.audsid = userenv('sessionid')
     and c.name = 'user_dump_dest'
/

exec dbms_monitor.session_trace_enable
!ls &TRACE
