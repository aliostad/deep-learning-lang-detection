USE [UA_NAV]
GO
/****** Object:  StoredProcedure [dbo].[Scenic_Places]    Script Date: 4/24/2015 2:19:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[Scenic_Places] @no_of_tables INT
AS
BEGIN
SET nocount ON
	DECLARE @i INT
	SET @i=0
	DECLARE @cnt INT
	DECLARE @var varchar(10)
	DECLARE @insert_query  VARCHAR(1000)
	DECLARE @create_query  VARCHAR(1000)
	DECLARE @drop_query  VARCHAR(1000)

	SET @insert_query=''
WHILE(@i<@no_of_tables-1)
BEGIN
	SET @var = @i
	
	
	SET @insert_query = @insert_query + ' SELECT TOP 2 ADDRESS FROM [UA_NAV].[dbo].[Places_'+ @var+'] WHERE weather IN (''Light Rain'') OR temperature>''50'' OR Traffic >''1'' OR Safety >''2'' UNION'
	--SET @create_query = 'CREATE TABLE Places_' + @var + '(Scenic_Place_Name varchar(100) , Latitude varchar(100) , Longitude varchar(100) , Address varchar(100) , Zipcode varchar(100) , Weather varchar(100) , Temperature varchar(100) , Traffic varchar(100), Safety varchar(100))'


	
	SET @i=@i+1

	
END
	SET @var = @i
	SET @insert_query = @insert_query + ' SELECT TOP 2 ADDRESS FROM [UA_NAV].[dbo].[Places_'+ @var+'] WHERE weather IN (''Light Rain'') OR temperature>''50'' OR Traffic >''1'' OR Safety >''2'' '
	SET @create_query = 'SELECT * INTO [UA_NAV].[dbo].[Way_Points_Table] FROM (' + @insert_query + ') AS a'

	
	SELECT @cnt=COUNT(*)
	FROM information_schema.tables
	WHERE TABLE_CATALOG='UA_NAV' AND TABLE_SCHEMA='dbo' AND TABLE_NAME='Way_Points_Table'

	SET @drop_query = 'DROP TABLE [UA_NAV].[dbo].[Way_Points_Table]'

	if(@cnt=1)
	BEGIN
	
	exec (@drop_query)
	exec (@create_query)
	print @create_query
	END
	ELSE
	BEGIN
	exec (@create_query)

	

	END

END