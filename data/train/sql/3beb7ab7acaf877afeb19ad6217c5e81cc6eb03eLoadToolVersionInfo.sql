/****** Object:  StoredProcedure [dbo].[LoadToolVersionInfo] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure dbo.LoadToolVersionInfo
/****************************************************
**
**	Desc:	Load Tool version info for specified tool in specified folder
**
**	Return values: 0: success, otherwise, error code
**
**	Parameters:
**
**	Auth:	mem
**	Date:	12/30/2011 mem - Initial Version
**
*****************************************************/
(
	@AnalysisToolName varchar(128),						-- Sequest, Masic_Finnigan, XTandem, MSGF, etc.
	@StoragePathResults varchar(512),					-- Path to the folder to look for the Tool version info file, e.g. Tool_Version_Info_MSGF.txt
	@Job int,											-- Only used for logging purposes; this procedure does not update T_Analysis_Description
	@ToolVersionInfo varchar(512) = '' OUTPUT,			-- Tool version info read from the tool version info file
	@message varchar(255) = '' OUTPUT,
	@RaiseErrorIfFileNotFound tinyint = 0				-- If 0 and if file not found, then returns 0; if non-zero and file not found, then returns 53002
)
AS
	Set nocount on

	Declare @myError int
	Declare @myRowCount int
	Set @myError = 0
	Set @myRowCount = 0

	Declare @fileExists tinyint

	-----------------------------------------------
	-- Clear the outputs
	-----------------------------------------------
	Set @ToolVersionInfo = ''
	Set @message = ''
	
	Declare @jobStr varchar(12)
	If @Job Is Null
		Set @jobStr = '??'
	Else
		Set @jobStr = convert(varchar(12), @Job)
	
	If IsNull(@AnalysisToolName, '') = ''
	Begin
		Set @message = '@AnalysisToolName parameter is empty; unable to continue'
		Return 53000
	End
	
	If IsNull(@StoragePathResults, '') = ''
	Begin
		Set @message = '@StoragePathResults parameter is empty; unable to continue'
		Return 53001
	End	
	
	-----------------------------------------------
	-- See if the Tool Version Info file exists
	-----------------------------------------------
	
	Declare @ToolVersionInfoFileName varchar(512)
	Declare @ToolVersionInfoFilePath varchar(512)
	Declare @FileCountFound int = 0
	Declare @FileCountMissing int = 0
	
	Set @ToolVersionInfoFileName = 'Tool_Version_Info_' + @AnalysisToolName + '.txt'
	Set @ToolVersionInfoFilePath = dbo.udfCombinePaths(@StoragePathResults, @ToolVersionInfoFileName)

	exec ValidateFilesExist @StoragePathResults, @ToolVersionInfoFileName, @FileCountFound = @FileCountFound output, @FileCountMissing = @FileCountMissing output
	
	If @FileCountMissing > 0
	Begin
		Set @message = 'Tool version info file not found for job ' + @jobStr + ', tool ' + @AnalysisToolName + ' (' + @ToolVersionInfoFilePath + ')'
		
		If @RaiseErrorIfFileNotFound = 0
			Return 0
		Else
			Return 53002

	End

	-----------------------------------------------
	-- We will bulk load the data into T_ToolVersionInfoContents using view V_ToolVersionInfo_Append
	-- We do this to assure that the data is loaded from the file into the table in the same order as the file
	-- We can then use the EntryID column to determine the row just after the 'ToolVersionInfo:' row
	--
	-- Before loading new data, delete entries from T_ToolVersionInfoContents that are over 5 minutes old
	-----------------------------------------------
	--
	DELETE FROM T_ToolVersionInfoContents
	WHERE Entered < DateAdd(minute, -5, GetDate())
	
	-----------------------------------------------
	-- Start a transaction, then lookup the max EntryID value in T_ToolVersionInfoContents
	-- (the table may be empty)
	-----------------------------------------------
	Declare @EntryIDStart int = 0
	Declare @EntryIDEnd int = 0
	Declare @ToolVersionTran varchar(32) = 'Tool version info transaction'
	
	Begin Tran @ToolVersionTran
	
	SELECT @EntryIDStart = MAX(EntryID)
	FROM T_ToolVersionInfoContents
	
	Set @EntryIDStart = IsNull(@EntryIDStart, 0) + 1
	
	-----------------------------------------------
	-- Bulk load the tool version info file
	-- We use view V_ToolVersionInfo_Append since this view only has one column and the text file should only have one column
	-----------------------------------------------
	--
	Declare @c nvarchar(2048)

	Set @c = 'BULK INSERT V_ToolVersionInfo_Append FROM ' + '''' + @ToolVersionInfoFilePath + ''' WITH (FIRSTROW = 1)' 
	exec @myError = sp_executesql @c
	--
	if @myError <> 0
	begin
		Set @message = 'Problem executing bulk insert into V_ToolVersionInfo_Append for job ' + @jobStr
		Rollback tran @ToolVersionTran
		return 53006
	end

	-----------------------------------------------
	-- Lookup the new max EntryID value in T_ToolVersionInfoContents
	-- then commit the transaction
	-----------------------------------------------
	
	SELECT @EntryIDEnd = MAX(EntryID)
	FROM T_ToolVersionInfoContents
	
	Set @EntryIDEnd = IsNull(@EntryIDEnd, @EntryIDStart)
	
	Commit tran @ToolVersionTran
	
	-----------------------------------------------
	-- Query out the first line after the "ToolVersionInfo:" line
	-----------------------------------------------
	
	SELECT @ToolVersionInfo = TVI.Data
	FROM T_ToolVersionInfoContents TVI
	     INNER JOIN ( SELECT EntryID
	                  FROM T_ToolVersionInfoContents
	                  WHERE Data LIKE 'ToolVersionInfo:%' AND
	                        EntryID BETWEEN @EntryIDStart AND @EntryIDEnd
	                ) FilterQ
	       ON TVI.EntryID = FilterQ.EntryID + 1
	--	
	SELECT @myRowCount = @@rowcount, @myError = @@error
	
	If @myError <> 0
	Begin
		Set @message = 'Error extracting ToolVersionInfo text from T_ToolVersionInfoContents'
	End
	
	If @myRowCount = 0
	Begin
		-- Match not found; query T_ToolVersionInfoContents for the first row that doesn't start with one of the known row headers
		SELECT Top 1 @ToolVersionInfo = Data
		FROM T_ToolVersionInfoContents
		WHERE EntryID BETWEEN @EntryIDStart AND @EntryIDEnd AND
			NOT Data LIKE 'Date:%' AND
			NOT Data LIKE 'Dataset:%' AND
			NOT Data LIKE 'Job:%' AND
			NOT Data LIKE 'Step:%' AND
			NOT Data LIKE 'Tool:%' AND
			NOT Data LIKE 'ToolVersionInfo:%'
		ORDER BY EntryID
		--	
		SELECT @myRowCount = @@rowcount, @myError = @@error
	
	End
	
	-----------------------------------------------
	-- Exit
	-----------------------------------------------
Done:
	Return @myError


GO
