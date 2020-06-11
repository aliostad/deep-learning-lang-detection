set search_path=climate_change,public;

create temp table diff as 
with new as (
 select pid,scenario,i,(weather[i]).* 
 from pixel_weather, generate_series(123,123+11) as i 
 where scenario='A1B' and pid=286937
),
cur as (
 select pid,scenario,i,(weather[i]).* 
 from pixel_weather, generate_series(123+2,123+2+11) as i
 where scenario='A1B' and pid=286937
) 
select pid,scenario,
(avg((new.tmax+new.tmin)/2)-avg((cur.tmax+cur.tmin)/2))::decimal(6,2) as dtmean,
sum(new.ppt) as new, sum(cur.ppt) as cur,
(sum(new.ppt)-sum(cur.ppt))::decimal(6,2) as dppt
from new join cur using (pid,scenario,i)
group by pid,scenario;

\COPY diff to foo.csv with CSV HEADER
