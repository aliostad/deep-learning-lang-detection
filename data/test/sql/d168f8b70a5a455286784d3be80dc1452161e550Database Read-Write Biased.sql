/*
DROP TABLE #ReadWriteTemp

SELECT [divfs].[database_id] ,
         [divfs].[file_id] ,
         [divfs].[sample_ms] ,
         [divfs].[num_of_reads] ,
         [divfs].[num_of_bytes_read] ,
         [divfs].[io_stall_read_ms] ,
         [divfs].[num_of_writes] ,
         [divfs].[num_of_bytes_written] ,
         [divfs].[io_stall_write_ms] ,
         [divfs].[io_stall] ,
         [divfs].[size_on_disk_bytes] ,
         [divfs].[file_handle]
   INTO	#ReadWriteTemp         
   FROM [sys].[dm_io_virtual_file_stats](NULL, NULL) AS divfs

*/

SELECT
    DB_NAME([divfs].[database_id]) AS [database] ,
    [mf].[type_desc] AS [file type] ,
    mf.[name] AS [file name] ,
    CONVERT(DECIMAL(16, 3), CONVERT(BIGINT, [mf].[size]) / 128.0) AS [size_mb] ,
    CONVERT(DECIMAL(10, 2), ( [divfs].[sample_ms] - [t].[sample_ms] ) / 1000.0) AS [elapsed time s] ,
    [divfs].[num_of_reads] - [t].[num_of_reads] AS [reads] ,
    [divfs].[num_of_bytes_read] - [t].[num_of_bytes_read] AS [bytes read] ,
    [divfs].[io_stall_read_ms] - [t].[io_stall_read_ms] AS [stall read] ,
    CASE WHEN ( [divfs].[io_stall_read_ms] - [t].[io_stall_read_ms] )
              - ( [divfs].[io_stall_write_ms] - [t].[io_stall_write_ms] ) > 0
         THEN '<< Read Bias'
         WHEN ( [divfs].[io_stall_read_ms] - [t].[io_stall_read_ms] )
              - ( [divfs].[io_stall_write_ms] - [t].[io_stall_write_ms] ) < 0
         THEN 'Write Bias >>'
         ELSE '<Balanced>'
    END AS [Stall Balance] ,
    CASE WHEN ( [divfs].[num_of_bytes_read] - [t].[num_of_bytes_read] )
              - ( [divfs].[num_of_bytes_written] - [t].[num_of_bytes_written] ) > 0
         THEN '<< Read Bias'
         WHEN ( [divfs].[num_of_bytes_read] - [t].[num_of_bytes_read] )
              - ( [divfs].[num_of_bytes_written] - [t].[num_of_bytes_written] ) < 0
         THEN 'Write Bias >>'
         ELSE '<Balanced>'
    END AS [Read/Write Balance] ,
    [divfs].[num_of_writes] - [t].[num_of_writes] AS [writes] ,
    [divfs].[num_of_bytes_written] - [t].[num_of_bytes_written] AS [bytes write] ,
    [divfs].[io_stall_write_ms] - [t].[io_stall_write_ms] AS [stall write] ,
    [divfs].[io_stall] - [t].[io_stall] AS [stall] ,
    [divfs].[size_on_disk_bytes] - [t].[size_on_disk_bytes] AS [size change]
   FROM
    [sys].[dm_io_virtual_file_stats](NULL, NULL) AS divfs
   INNER JOIN #ReadWriteTemp AS t
   ON
    [divfs].[database_id] = [t].[database_id]
    AND [divfs].[file_handle] = [t].[file_handle]
   INNER JOIN [sys].[master_files] AS mf
   ON
    [t].[database_id] = [mf].[database_id]
    AND [t].[file_id] = [mf].[file_id]
   WHERE
    [divfs].[database_id] = 2
    OR [divfs].[database_id] = 1
    OR [divfs].[database_id] = DB_ID()
   ORDER BY
    ( [divfs].[num_of_bytes_read] - [t].[num_of_bytes_read] )
    + ( [divfs].[num_of_bytes_written] - [t].[num_of_bytes_written] ) DESC 
    
    
    
    