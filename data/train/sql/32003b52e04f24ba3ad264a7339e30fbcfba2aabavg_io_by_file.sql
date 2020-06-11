set pages 9999;

column snapdate format a16
column filename format a40
column mydate heading 'Yr. Mo Dy  Hr.' format a16

select 
   to_char(snap_time,'yyyy-mm-dd') mydate,
--   old.filename,
   sum(new.phyrds-old.phyrds)   phy_rds,
   sum(new.phywrts-old.phywrts) phy_wrts
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   new.snap_id = sn.snap_id
and
   old.filename = new.filename
and
   old.snap_id = sn.snap_id-1
and
   (new.phyrds-old.phyrds) > 0
and
   old.filename like '%&1%'
group by
   to_char(snap_time,'yyyy-mm-dd'),
   old.filename
order by
   to_char(snap_time,'yyyy-mm-dd')
;
