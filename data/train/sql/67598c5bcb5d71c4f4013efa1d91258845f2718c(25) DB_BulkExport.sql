USE SQL#Presentation
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @row_count int;

-- Output a query to a file
EXEC SQL#.DB_BulkExport
	@Query = 'SELECT * FROM AdventureWorks.Production.Product',
	@TextQualifier = '"',  
	@TextQualifyAllColumns = 0, -- 1 = qualify all columns, 0 = qualify only character, date, and uniqueidentifer data types
	@ColumnHeaderHandling = 'Results', -- Always, Results, Never  (NULL or empty string = Always)
	@BitHandling = 'Number', -- Word (default)(True or False), Letter (T or F), Number (1,0)
	@FirstRow = 0, -- The first result row to export (0 = ignore)
	@LastRow = 0, -- The last result row to export (0 = ignore)
	@FieldTerminator = '|',
	@RowTerminator = NULL,  -- can be any characters, but default (NULL) = CR/LF \r\n
	@OutputFilePath = 'C:\users\sumlin\desktop\products.txt',
	@FileEncoding = 'ASCII',
	@AppendFile = 0,  -- 0 = if file exists, file will be replaced.  1 = if file exists, file will be appended.
	@RowsExported = @row_count OUT; -- returns the number of records / rows exported....optional

SELECT @row_count AS [Number of Rows From Product Table]