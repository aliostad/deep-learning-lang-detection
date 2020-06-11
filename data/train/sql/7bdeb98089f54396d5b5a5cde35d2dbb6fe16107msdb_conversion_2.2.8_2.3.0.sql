INSERT db_schema_info (major_no, minor_no, release_no, comments)
VALUES (2,3,0, 'Model Scaling')
GO

alter table model_info
ADD [pop_size] [int] NOT NULL DEFAULT 0
GO

update model_info
set pop_size = 
CASE 
	WHEN (select COUNT(*) from segment where segment.model_id = model_info.model_id) > 0
	THEN (select SUM(segment_size) from segment where segment.model_id = model_info.model_id)
	ELSE 0
END
GO

alter table segment
alter column segment_size [float] NOT NULL
GO 

update segment
set segment_size =
CASE 
	WHEN (Select SUM(pop_size) from model_info where model_info.model_id = segment.model_id)> 0
	THEN 100* segment_size /(Select SUM(pop_size) from model_info where model_info.model_id = segment.model_id)
ELSE 0
END
GO

alter table scenario
add [scale_factor] [float] NOT NULL default 100
GO