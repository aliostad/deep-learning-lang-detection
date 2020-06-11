--DateTimeLastRead, TotalReads, DateTimeLastStoryPublished

IF NOT EXISTS(
	SELECT * FROM sys.tables [table] INNER JOIN sys.columns [column] ON [table].object_id = [column].object_id 	
	WHERE [table].name = 'MixmagRead' 
	AND	[column].name = 'DateTimeLastRead'
) BEGIN

ALTER TABLE dbo.MixmagRead ADD
	DateTimeLastRead datetime NULL
	
EXECUTE sp_addextendedproperty N'MS_Description', N'Date/time the issue was last read.', N'SCHEMA', N'dbo', N'TABLE', N'MixmagRead', N'COLUMN', N'DateTimeLastRead'

END



IF NOT EXISTS(
	SELECT * FROM sys.tables [table] INNER JOIN sys.columns [column] ON [table].object_id = [column].object_id 	
	WHERE [table].name = 'MixmagRead' 
	AND	[column].name = 'TotalReads'
) BEGIN

ALTER TABLE dbo.MixmagRead ADD
	TotalReads int NULL
	
EXECUTE sp_addextendedproperty N'MS_Description', N'Total number of reads.', N'SCHEMA', N'dbo', N'TABLE', N'MixmagRead', N'COLUMN', N'TotalReads'

END




IF NOT EXISTS(
	SELECT * FROM sys.tables [table] INNER JOIN sys.columns [column] ON [table].object_id = [column].object_id 	
	WHERE [table].name = 'MixmagRead' 
	AND	[column].name = 'DateTimeLastStoryPublished'
) BEGIN

ALTER TABLE dbo.MixmagRead ADD
	DateTimeLastStoryPublished datetime NULL
	
EXECUTE sp_addextendedproperty N'MS_Description', N'Date/time that the last stream story was published.', N'SCHEMA', N'dbo', N'TABLE', N'MixmagRead', N'COLUMN', N'DateTimeLastStoryPublished'

END
