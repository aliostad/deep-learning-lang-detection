USE [CarSellDb]
GO
/****** Object:  StoredProcedure [dbo].[DeleteFromMaster]    Script Date: 11/23/2014 15:12:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteFromMaster]
	@BrandIdVal numeric=0,
	@ModelIdVal numeric=0,
	@CarIdVal numeric=0
AS
BEGIN
	SET NOCOUNT ON;
	--Start Transaction
	Begin Transaction
		if OBJECT_ID('ModelIds','u') is not null
			DROP table ModelIds
		
		if OBJECT_ID('CarIds','u') is not null
			DROP table CarIds
		
		CREATE TABLE #ModelIds ( modelid numeric)
		CREATE TABLE #CarIds ( CarId numeric)
		
		if(@BrandIdVal>0)
		begin
			Select ModelId Into ModelIds from ModelMaster where BrandId=@BrandIdVal
			Select CarId Into CarIds from CarMaster where ModelId in (Select ModelId from ModelIds)
		end
		else if(@ModelIdVal>0)
		begin
			Select ModelId Into ModelIds from ModelMaster where ModelId=@ModelIdVal
			Select CarId Into CarIds from CarMaster where ModelId in (Select ModelId from ModelIds)
		end
		
		
		if(@CarIdVal>0)
		begin
			Select CarId Into CarIds from CarMaster where CarId=@CarIdVal
		end
				
		--Now delete One by One
		Delete BrandMaster where BrandID=@BrandIdVal
		Delete ModelMaster where ModelId in (Select ModelId from ModelIds)
		Delete CarMaster where CarId in (Select CarId from CarIds)
		Delete AppointmentDetails where CarId in (Select CarId from CarIds)
	
	IF(@@ERROR=0)
	BEGIN
		COMMIT
	END
	ELSE
	BEGIN
		ROLLBACK
	END


END
