 DECLARE	@job_name			sysname
			,@job_id			uniqueidentifier
			,@output_file_name	nvarchar(200)
  
 SET		@job_name			= 'APPL - PumpAudio DB Refresh'
 
 -- GET JOB_ID FROM JOB NAME
 SELECT		@job_id				= job_id
 FROM		msdb.dbo.sysjobs
 WHERE		name = @job_name

-- GET EXISTING STEP1 OUTPUT FILE NAME
SELECT		@output_file_name	= output_file_name 
From		msdb.dbo.sysjobsteps
WHERE		job_id = @job_id
	AND		step_id = 1
 
exec msdb.dbo.sp_add_jobstep @job_name = @job_name
		,@step_id			= 1
		,@step_name			= 'Check for Production Environment'
		,@subsystem			= 'TSQL'
		,@command			= 'IF (SELECT [env_detail] FROM [dbaadmin].[dbo].[Local_ServerEnviro] WHERE [env_type] = ''ENVname'') != ''production'' RAISERROR(''DBA INFO: JOB NOT NEEDED IN NON-PRODUCTION ENVIRONMENT, ABORTING.'',16,-1) WITH LOG'
		,@on_success_action	= 3 -- GO TO NEXT STEP
		,@on_fail_action	= 1 -- EXIT WITH SUCCESS
		,@output_file_name	= @output_file_name
		,@flags				= 38 -- Append Output = 2, Write tsql output = 4, Write all output = 32
