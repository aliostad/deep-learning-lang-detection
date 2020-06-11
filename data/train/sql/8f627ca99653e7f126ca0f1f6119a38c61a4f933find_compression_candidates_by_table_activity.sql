-- find candidates for compression based on read/write activity

with [ios] as (
	select
		i.[object_id],
		[p#] = i.[partition_number],
		i.[index_id],
		[write_perc] = Convert(decimal(5,2), i.[leaf_update_count] * 100.0 / (i.[range_scan_count] + i.[leaf_insert_count] + i.[leaf_delete_count] + i.[leaf_update_count] + i.[leaf_page_merge_count] + i.[singleton_lookup_count])),
		[read_perc] = Convert(decimal(5,2), i.[range_scan_count] * 100.0 / (i.[range_scan_count] + i.[leaf_insert_count] + i.[leaf_delete_count] + i.[leaf_update_count] + i.[leaf_page_merge_count] + i.[singleton_lookup_count]))
	from
		sys.dm_db_index_operational_stats (db_id(), null, null, null) [i]
	where
		ObjectProperty(i.[object_id], 'IsUserTable') = 1
		and (i.[range_scan_count] + i.[leaf_insert_count] + i.[leaf_delete_count] + i.[leaf_update_count] + i.[leaf_page_merge_count] + i.[singleton_lookup_count]) > 0
)		
select
	[table_name] = o.[name],
	[index_name] = x.[name],
	ios.[p#],
	ios.[index_id],
	x.[type_desc],
	ios.[write_perc],
	ios.[read_perc],
	[compression_candidate] =
		case
			when ios.[write_perc] < 5.0 and ios.[read_perc] > 90.0		then 'EXCELLENT'
			when ios.[write_perc] < 15.0 and ios.[read_perc] > 90.0		then 'VERY GOOD'
			when ios.[write_perc] < 5.0 or ios.[read_perc] > 90.0		then 'GOOD'
			when ios.[write_perc] < 15.0 and ios.[read_perc] > 25.0		then 'OKAY'
			when ios.[write_perc] > 15.0								then 'NO'
			else 'ASK ME LATER'
		end
from
	[ios]
	inner join sys.objects [o] on ios.[object_id] = o.[object_id]
	left outer join sys.indexes [x] on ios.[object_id] = x.[object_id] and ios.[index_id] = x.[index_id]
order by
	ios.[write_perc] desc,
	ios.[read_perc] desc ;
go
