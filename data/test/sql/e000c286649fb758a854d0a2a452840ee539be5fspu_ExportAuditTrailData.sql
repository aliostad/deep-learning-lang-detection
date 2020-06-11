---------------------------------------------------------------------
--	PROCEDURE:	
--		spu_ExportAuditTrailData
-- ARGUMENTS:	
--		@userid				int
-- DESCRIPTION:
--
-- This procedure returns security access attempts.
--
----------------------------------------------------------------
-- EXAMPLE
--    exec spu_ExportAuditTrailData
---------------------------------------------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE name like 'spu_ExportAuditTrailData')
	DROP PROC spu_ExportAuditTrailData
go

CREATE PROC spu_ExportAuditTrailData
	@adt_bdate				DATETIME,
	@adt_edate				DATETIME AS

DECLARE @division_name	VARCHAR( 50 )

SELECT	@division_name = d.division_name 
FROM	im_division d join sy_system s on d.division_id = s.default_division_id

	SELECT	create_by as [export_user], 
			@division_name as division_name,
			create_date as [export_date], 
			new_value as [report_details], 
			CASE 
				WHEN CHARINDEX('R::', new_value) > 0 THEN SUBSTRING( new_value, 4, CHARINDEX(' C::', new_value) - 4)
				WHEN CHARINDEX(' to ', new_value) > 0 THEN SUBSTRING( new_value, 1, CHARINDEX(' to ', new_value))
				ELSE new_value 
			END as report,
			CASE
				WHEN CHARINDEX(' C::', new_value) > 0 THEN SUBSTRING( new_value, CHARINDEX(' C::', new_value) + 4, CHARINDEX(' T::', new_value) - CHARINDEX(' C::', new_value) - 4)
				WHEN CHARINDEX(' to ', new_value) > 0 THEN 'Exported to ' + SUBSTRING( new_value, CHARINDEX(' to ', new_value) + 4, 999)
			END as criteria,
			CASE WHEN CHARINDEX(' T::', new_value) > 0 THEN
				SUBSTRING( new_value, CHARINDEX(' T::', new_value) + 4, 999)
			END as rows
	FROM	sy_at
	WHERE	table_name = 'Export' AND
			create_date between @adt_bdate AND @adt_edate
	ORDER BY create_date


go