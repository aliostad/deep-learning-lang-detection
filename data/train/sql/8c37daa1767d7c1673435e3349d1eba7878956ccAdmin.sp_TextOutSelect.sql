SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Admin].[sp_TextOutSelect] (
	@Select nvarchar(max),
	@FileName nvarchar(150),
	@FieldTerminator nvarchar(1) = ','
	)
AS
BEGIN
DECLARE @TempViewName nvarchar(200)
SET @TempViewName = '[AdHoc].[TempView_SelectOut]'
SET @Select = 'CREATE VIEW ' + @TempViewName + ' 
AS
' + @Select

--Remove existing view
IF OBJECT_ID(@TempViewName,N'V') IS NOT NULL DROP VIEW [AdHoc].[TempView_SelectOut]  

--Create TempView
EXECUTE sp_executesql @Select
--Export data from TempView
SET @TempViewName  = '[Admin].' + @TempViewName
SET @FileName = '\\oldham-vfiler-01\ccg\Information, Intelligence & IT\BI - Business Intelligence\Data Flows\p_TextOutTable Destination\' + @FileName
Print @TempViewName + ', ' + @FileName
EXECUTE [Admin].[Admin].[sp_TextOutTable] @TempViewName, @FileName

--Cleanup
IF OBJECT_ID(@TempViewName,N'V') IS NOT NULL DROP VIEW [AdHoc].[TempView_SelectOut]  
END
