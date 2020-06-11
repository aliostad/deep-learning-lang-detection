Declare @NewDbName Varchar(Max)

Set @NewDbName = 'RankTrend-JY'

If @NewDbName = 'RankTrend'
	Select * from OhCrap

Declare @FileName Varchar(Max)

Set @FileName = 'c:\Backup\Sql\' + @NewDbName + '.bak'

Backup Database RankTrend
To Disk = @FileName
With Format

Declare @RestoreCmd Varchar(Max)

Set @RestoreCmd =
	'Restore Database [' + @NewDbName + ']
	From Disk = ''' + @FileName + '''
	With
	Move ''RankTrend_Data'' To ''C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\' + @NewDbName + '.mdf'',
	Move ''RankTrend_Log'' To ''C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\' + @NewDbName + '.ldf'''

Print @RestoreCmd

Exec(@RestoreCmd)

/*

Drop Database [RankTrend-JY]

*/