/*
*
*			GET VIRTUAL FILE STATS
*			---------------------------------
*			
*			For data files, MS recommend:
*			
*			< 10 ms			= Good
*			10 - 20 ms		= Acceptable
*			> 20 ms			= Unacceptable
*
*
*			For log files, MS recommend:
*			
*			< 5 ms			= Good
*			5 - 15 ms		= Acceptable
*			> 15 ms			= Unacceptable
*
*/

	SELECT		DB_NAME(database_id)								AS 'Database_Name'
	,			CASE WHEN file_id = 2 THEN 'Log' ELSE 'Data' END	AS 'File_Type'
	,			((size_on_disk_bytes/1024)/1024.0)					AS 'Size_On_Disk_in_MB'
	,			io_stall_read_ms / num_of_reads						AS 'Avg_Read_Transfer_in_Ms'
	,			CASE WHEN file_id = 2 THEN
					CASE 
						WHEN io_stall_read_ms / num_of_reads < 5 THEN
							'Good'
						WHEN io_stall_read_ms / num_of_reads < 15 THEN 
							'Acceptable'
						ELSE 
							'Unacceptable'
					END
				ELSE
					CASE 
						WHEN io_stall_read_ms / num_of_reads < 10 THEN
							'Good'
						WHEN io_stall_read_ms / num_of_reads < 20 THEN 
							'Acceptable'
						ELSE 
							'Unacceptable'
					END											
				END													AS 'Average_Read_Performance'
	,			io_stall_write_ms / num_of_writes					AS 'Avg_Write_Transfer_in_Ms'
	,			CASE WHEN file_id = 2 THEN
					CASE 
						WHEN io_stall_write_ms / num_of_writes < 5 THEN
							'Good'
						WHEN io_stall_write_ms / num_of_writes < 15 THEN 
							'Acceptable'
						ELSE 
							'Unacceptable'
					END
				ELSE
					CASE 
						WHEN io_stall_write_ms / num_of_writes < 10 THEN
							'Good'
						WHEN io_stall_write_ms / num_of_writes < 20 THEN 
							'Acceptable'
						ELSE 
							'Unacceptable'
					END											
				END													AS 'Average_Write_Performance'
	FROM		sys.dm_io_virtual_file_stats(null,null) 
	WHERE		num_of_reads > 0 AND num_of_writes > 0
GO