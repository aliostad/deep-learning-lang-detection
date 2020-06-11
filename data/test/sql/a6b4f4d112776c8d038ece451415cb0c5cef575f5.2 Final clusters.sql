use patstat
go

--select * from sample_table
---------------------------------
-- Add non-clustered publications

-- Collect all non-clustered combinations of blocks and publications.
if object_id('tempdb.dbo.#new_ids_nonclustered') is not null drop table #new_ids_nonclustered
select new_id
into #new_ids_nonclustered
from sample_unique
except
select new_id
from npl_publn_clusters
go

-- Prepare separate cluster numbers for all non-clustered publications.
if object_id('tempdb.dbo.#new_ids_clusters_inserts') is not null drop table #new_ids_clusters_inserts
select new_id, rank_no = row_number() over (order by new_id)
into #new_ids_clusters_inserts
from #new_ids_nonclustered
group by new_id

--deterternube nax clusters
declare @max_cluster int = (select max(cluster) from npl_publn_clusters)

-- Insert all non-clustered new_ids as separate clusters.
insert into npl_publn_clusters(cluster, new_id)
(select cluster = (@max_cluster + rank_no), new_id
from #new_ids_clusters_inserts)
go
--------------------------------
-- Add results from pre-cleaning

if object_id('final_clusters') is not null drop table final_clusters
select a.cluster, b.npl_publn_id
into final_clusters
from npl_publn_clusters as a
join sample_glue as b on a.new_id = b.new_id
go

--Clean up
if object_id('tempdb.dbo.#new_ids_clusters_inserts') is not null drop table #new_ids_clusters_inserts
if object_id('tempdb.dbo.#new_ids_nonclustered') is not null drop table #new_ids_nonclustered

--Inspect
select * from final_clusters
order by cluster asc