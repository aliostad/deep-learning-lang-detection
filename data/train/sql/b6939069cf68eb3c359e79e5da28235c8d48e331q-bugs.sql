select regcode,DUMP(regcode,1016),DUMP('¾© ',1016),vsize(regcode),vsize('¾© ') from gps_trace_20121114 where traceid = 'GPS_553912017';

select * from gps_trace_20121114 where traceid = 'GPS_553912017' and regcode like '%' || chr(0) || '%';

select * from gps_trace_20121114 where regcode like '%' || chr(0) || '%';

select * from gps_trace_20121114 where traceid = 'GPS_553912017';

select 'a' || chr(66) || 'p' from dual;

select DUMP('abc', 1016) from dual;

-- GPS_553912017,GPS_554197201

select * from gps_trace_20121116 order by entertime desc;