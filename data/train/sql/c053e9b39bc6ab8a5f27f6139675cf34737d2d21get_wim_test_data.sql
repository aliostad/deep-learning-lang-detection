-- scratch work to select sufficient WIM data to run tests.


copy (
   select *
   from wim_data a
   where a.ts>='2012-01-01'
      and a.ts<'2012-03-01'
      and a.site_no in (87,37)
) to '/tmp/some_wim_data.dump'
with (format binary);

copy (
   select *
   from wim_data a
   where a.ts>='2012-01-01'
      and a.ts<'2012-03-01'
      and a.site_no in (83)
      order by random()
      limit 99
) to '/tmp/some_more_wim_data.dump'
with (format binary);




copy (
  select *
  from wim.summaries_5min_speed b
  where b.ts>='2012-01-01'
  and b.ts<'2013-03-01'
  and b.site_no in (87,83,37)
) to '/tmp/some_wim_summaries_5min_speed.dump'
with (format binary);
