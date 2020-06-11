USE [HCL2]
GO
/****** Object:  StoredProcedure [dbo].[GetCars]    Script Date: 3/3/2015 9:32:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetCars]
    -- Add the parameters for the stored procedure here
    @op varchar(50)=' ', 
     @year varchar(10)=' ', 
     @make varchar(50)=' ', 
     @model varchar(50)=' ', 
     @trim varchar(MAX)=' '

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    if @op='YMDT'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year AND make = @make AND model_name = @model AND model_trim = @trim Order By model_year,make,model_name,model_trim ASC
    End

	if @op='YDT'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year AND model_name = @model AND model_trim = @trim Order By model_year,make,model_name,model_trim ASC
    End

    if @op='MDT'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE make = @make AND model_name = @model AND model_trim = @trim Order By model_year,make,model_name,model_trim ASC
    End

	if @op='YMD'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year AND make = @make AND model_name = @model Order By model_year,make,model_name,model_trim ASC
    End

	if @op='YMT'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year AND make = @make AND model_trim = @trim Order By model_year,make,model_name,model_trim ASC
    End

	if @op='YM'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year AND make = @make Order By model_year,make,model_name,model_trim ASC 
    End

	if @op='MD'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE make = @make AND model_name = @model Order By model_year,make,model_name,model_trim ASC
    End

	if @op='MT'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE make = @make AND model_trim = @trim Order By model_year,make,model_name,model_trim ASC 
    End

	if @op='YD'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year AND model_name = @model Order By model_year,make,model_name,model_trim ASC
    End

    if @op='YT'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year AND model_trim = @trim Order By model_year,make,model_name,model_trim ASC
    End

	if @op='DT'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_name = @model AND model_trim = @trim Order By model_year,make,model_name,model_trim ASC 
    End

	if @op='Y'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_year = @year Order By model_year,make,model_name,model_trim ASC
    End

	if @op='M'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE make = @make Order By model_year,make,model_name,model_trim ASC
    End

	if @op='D'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_name = @model Order By model_year,make,model_name,model_trim ASC
    End

	if @op='T'
    BEGIN
    -- Insert statements for procedure here
    SELECT * FROM Cars WHERE model_trim = @trim Order By model_year,make,model_name,model_trim ASC
    End

END
