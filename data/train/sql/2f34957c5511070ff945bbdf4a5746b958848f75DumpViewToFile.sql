/****** Object:  StoredProcedure [dbo].[DumpViewToFile] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure DumpViewToFile
/****************************************************
**
**	Desc: 
**		Creates a flat file containing contents
**		for given view
**
**	Return values: 0: success, otherwise, error code
**
**	Parameters:
**
**		Auth: grk
**		Date: 12/02/2002
**			  11/23/2005 mem - Added brackets around @dbName as needed to allow for DBs with dashes in the name

**    
*****************************************************/
	@dbName varchar(64) = 'MT_Deinococcus_P12',
	@viewName varchar(128) = 'V_Junk_GRK1',
	@outFileDir varchar(256) = 'E:\BCP\',
	@outFileName varchar(256) = 'dump.txt'
As
	set nocount on
	
	declare @myError int
	set @myError = 0

	declare @outFilePath varchar(256)

	declare @cmd varchar(255)
	declare @result int

	declare @lockerCount varchar(12)

	--------------------------------------------------------------
	--  build output file name
	--------------------------------------------------------------
	declare @now datetime
	set @now = getdate()

	If Right(@outFileDir, 1) <> '\'
		Set @outFileDir = @outFileDir + '\'
		
	set @outFilePath = '"' + @outFileDir + @dbName + '_' + @outFileName + '"'
	

	--------------------------------------------------------------
	-- dump the view into the output file
	--------------------------------------------------------------
	-- 
	set @cmd = 'bcp [' + @dbName + ']..' + @viewName + ' out ' + @outFilePath + ' -c -T'
	--
	EXEC @result = master..xp_cmdshell @cmd, NO_OUTPUT 
	
		
	return 

GO
GRANT EXECUTE ON [dbo].[DumpViewToFile] TO [DMS_SP_User] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[DumpViewToFile] TO [MTS_DB_Dev] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[DumpViewToFile] TO [MTS_DB_Lite] AS [dbo]
GO
