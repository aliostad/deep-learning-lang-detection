/****** Object:  StoredProcedure [dbo].[PostLogEntryAddToCache] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create Procedure PostLogEntryAddToCache
/****************************************************
**
**	Desc:	Put a new log entry into a temp log table
**			This is useful for tracking log entries in the middle of a long transaction, where
**			  you don't want to put a lock on T_Log_Entries, but you do want to track log entries
**			After the transaction is committed, you can append the cached log using PostLogEntryFlushCache
**
**			The calling procedure must create the table for caching log entries
**
**		CREATE TABLE #Tmp_Cached_Log_Entries (
**			[Entry_ID] int IDENTITY(1,1) NOT NULL,
**			[posted_by] varchar(128) NULL,
**			[posting_time] datetime NOT NULL DEFAULT (GetDate()),
**			[type] varchar(128) NULL,
**			[message] varchar(4096) NULL,
**			[Entered_By] varchar(128) NULL DEFAULT (suser_sname()),
**		)
**
**
**	Return values: 0: success, otherwise, error code
*
**	Auth:	mem
**	Date:	08/26/2008
**    
*****************************************************/
(
	@type varchar(128),
	@message varchar(4096),
	@postedBy varchar(128)= 'na',
	@duplicateEntryHoldoffHours int = 0			-- Set this to a value greater than 0 to prevent duplicate entries being posted within the given number of hours
)
As

	Declare @duplicateRowCount int
	Set @duplicateRowCount = 0
	
	If IsNull(@duplicateEntryHoldoffHours, 0) > 0
	Begin
		SELECT @duplicateRowCount = COUNT(*)
		FROM #Tmp_Cached_Log_Entries
		WHERE Message = @message AND Type = @type AND Posting_Time >= (GetDate() - @duplicateEntryHoldoffHours)
	End

	If @duplicateRowCount = 0
	Begin
		INSERT INTO #Tmp_Cached_Log_Entries
			(posted_by, posting_time, type, message) 
		VALUES ( @postedBy, GETDATE(), @type, @message)
	End
	
	return 0

GO
GRANT VIEW DEFINITION ON [dbo].[PostLogEntryAddToCache] TO [MTS_DB_Dev] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[PostLogEntryAddToCache] TO [MTS_DB_Lite] AS [dbo]
GO
