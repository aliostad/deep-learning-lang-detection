SELECT DISTINCT
Constraint_Name AS [Constraint]
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE


select * from sys.indexes
where name like 'CRONUS%'


SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS


select * from INFORMATION_SCHEMA.TABLES

use [Demo Database NAV (5-0)]
select name from  sys.tables


select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'CRONUS Sverige AB$Employee'

select c.name from sys.columns c
inner join sys.tables t on c.object_id = t.object_id
where t.name = 'CRONUS Sverige AB$Employee'
order by t.name

select top 1 TableName from (
SELECT OBJECT_NAME(OBJECT_ID) TableName, st.row_count as antal
FROM sys.dm_db_partition_stats st
WHERE index_id < 2) x
where TableName like 'CRONUS%'
group by TableName, antal
order by antal desc








