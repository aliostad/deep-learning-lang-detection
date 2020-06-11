
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Steve Ledridge
-- Create date:		05/21/2010
-- Description:		Check for parameter replacement in JobStep
-- =============================================
DROP TRIGGER dbo.sysjobsteps_Insert_Update 
GO
CREATE TRIGGER dbo.sysjobsteps_Insert_Update 
   ON  dbo.sysjobsteps 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for trigger here
    UPDATE	dbo.sysjobsteps
	SET	output_file_name = [dbaadmin].[dbo].[dbaudf_GetSharePath] ([dbaadmin].[dbo].[dbaudf_getShareUNC] ('SQLjob_logs')) + '\' + REPLACE(sj.name,' ','_') + '.txt'
		,flags = I.flags | 2	-- Append to output file
				 | 4	-- Write Transact-SQL job step output to step history
				-- | 8	-- Write log to table (overwrite existing history)
				-- | 16	-- Write log to table (append to existing history)
    FROM	dbo.sysjobsteps sjs
    JOIN	Inserted I
	ON	sjs.job_id = I.job_id
	AND	sjs.step_id = I.step_id
    JOIN	dbo.sysjobs sj WITH(NOLOCK)
	ON	sj.job_id = sjs.job_id	
    

END
GO

