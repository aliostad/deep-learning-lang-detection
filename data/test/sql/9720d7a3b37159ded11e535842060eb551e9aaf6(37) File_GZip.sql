USE SQL#Presentation
GO

/*
Export a table into a text file
Look at the size
Compress it
Look at the compressed size
*/

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @row_count int,
		@file_name nvarchar(4000) = N'C:\users\sumlin\desktop\SQL# Presentation\contacts.txt';

-- Output a large number of records into a file
EXEC SQL#.DB_BulkExport
	@Query = 'SELECT * FROM AdventureWorks.Person.Contact',
	@TextQualifier = '"',  
	@TextQualifyAllColumns = 0,
	@ColumnHeaderHandling = 'Results',
	@BitHandling = 'Number',
	@FirstRow = 0, 
	@LastRow = 0, 
	@FieldTerminator = '|',
	@RowTerminator = NULL,  
	@OutputFilePath = @file_name,
	@FileEncoding = 'ASCII',
	@AppendFile = 0,  
	@RowsExported = @row_count OUT; 

-- number of rows
SELECT @row_count AS [Number of Rows From Product Table];

-- file size
SELECT 
	SQL#.Math_Convert([Length],'Byte','Megabyte') MB,
	*
FROM SQL#.File_GetFileInfo(@file_name);

-- compress it
SELECT SQL#.File_Gzip(@file_name,1,1)

-- new file size
SELECT
	SQL#.Math_Convert([Length],'Byte','Megabyte') MB,
	*
FROM SQL#.File_GetFileInfo(@file_name + N'.gz');
