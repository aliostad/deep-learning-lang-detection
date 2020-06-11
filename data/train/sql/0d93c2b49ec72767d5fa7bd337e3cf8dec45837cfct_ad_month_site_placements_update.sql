/*
 * Update the main fact table with the results from the latest pulls
 */

set @oldMaxRunId = (select max(max_run_id) from fct_ad_month_site_placements_max_run_id);
set @newMaxRunId = (select max(run_id) from fct_run_host_depth_ad);

drop table if exists tmp_update_fct_ad_month_site_placements;
create temporary table tmp_update_fct_ad_month_site_placements (
  `id` char(36) CHARACTER SET latin1 NOT NULL,
  `image_num` int(10) unsigned NOT NULL,
  `month` varchar(10) CHARACTER SET latin1 DEFAULT NULL,
  `hostId` char(36) CHARACTER SET latin1 NOT NULL,
  `path` varchar(255) CHARACTER SET latin1 NOT NULL,
  `month_first` date DEFAULT NULL,
  `month_last` date DEFAULT NULL,
  `depths` text CHARACTER SET latin1,
  `ad_count` bigint(21) NOT NULL DEFAULT '0',
  UNIQUE KEY `id` (`id`,`month`,`path`),
  Unique KEY `image_num` (`image_num`,`month`,`path`)
);

insert into tmp_update_fct_ad_month_site_placements
select
	f.id,
	f.image_num,
	concat(date_format(run.run_date, '%Y-%m'), '-01') as month,
	h.id as hostId,
	h.path,
	min(run.run_date) as month_first,
	max(run.run_date) as month_last,
	group_concat(distinct fct.depth order by fct.depth separator ', ') as depths,
	sum(fct.ad_count) as ad_count
from
	imageFile f
inner join
      fct_run_host_depth_ad fct
on
      f.id = fct.imageFileId
           and
      fct.run_id > @oldMaxRunId
inner join
      scraper_run run
on
      run.run_id = fct.run_id
inner join
      hosts h on fct.hostId = h.id
group by 1,2,3,4,5;

/* update existing */
update
fct_ad_month_site_placements agg,
tmp_update_fct_ad_month_site_placements new
set agg.ad_count = agg.ad_count + new.ad_count, agg.month_first = new.month_first, agg.depths = new.depths
where agg.id = new.id
and agg.image_num = new.image_num
and agg.month = new.month
and agg.path = new.path;

/* add any new rows not already in table */
insert into fct_ad_month_site_placements
select new.id, new.image_num, new.month, new.hostId, new.path, new.month_first, new.month_last, new.depths, new.ad_count
from tmp_update_fct_ad_month_site_placements new
left join fct_ad_month_site_placements agg
on agg.id = new.id and agg.month = new.month and agg.path = new.path
where agg.id is null;

drop table tmp_update_fct_ad_month_site_placements;

update fct_ad_month_site_placements_max_run_id set max_run_id = @newMaxRunId where max_run_id = @oldMaxRunId;