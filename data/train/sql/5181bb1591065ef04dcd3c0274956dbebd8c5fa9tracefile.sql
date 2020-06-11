col i_trace_file head TRACE_FILE_NAME for a120
SELECT    a.VALUE
       || b.symbol
       || c.instance_name
       || '_ora_'
       || d.spid
       || '.trc' i_trace_file
  FROM (SELECT VALUE
          FROM v$parameter
         WHERE NAME = 'user_dump_dest') a,
       (SELECT SUBSTR (VALUE, -6, 1) symbol
          FROM v$parameter
         WHERE NAME = 'user_dump_dest') b,
       (SELECT instance_name
          FROM v$instance) c,
       (SELECT spid
          FROM v$session s, v$process p, v$mystat m
         WHERE s.paddr = p.addr AND s.SID = m.SID AND m.statistic# = 0) d
/
