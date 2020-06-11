USE [206S215-20141065]
GO
/****** Object:  StoredProcedure [dbo].[CanoeSelectRentedReport]    Script Date: 6/08/2015 9:06:48 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[CanoeSelectRentedReport]
     @CID		int
	 
AS
	Begin
		IF (@CID != 0)
		BEGIN
			SELECT cal.Type, model.ModelID, main.IndCanoeID, main.ReturnDate,
				sub.Colour, sub.BatteryLife, sub.ManufactoredYear, sub.Accessories, sub.Status, sub.RentPerDay, sub.Deposit
			FROM Canoe_RentDetails main
			INNER JOIN Canoe_IndividualCanoe sub ON main.IndCanoeID=sub.IndCanoeID	
			INNER JOIN Canoe_Model model ON sub.ModelNo = model.ModelID
			LEFT OUTER JOIN Canoe_Category cal ON cal.CID = model.CategoryID
			WHERE cal.CID = @CID
			ORDER BY cal.CID, model.ModelID, main.IndCanoeID, main.ReturnDate
		End
		ELSE
		BEGIN
			SELECT cal.Type, model.ModelID, main.IndCanoeID, main.ReturnDate,
				sub.Colour, sub.BatteryLife, sub.ManufactoredYear, sub.Accessories, sub.Status, sub.RentPerDay, sub.Deposit
			FROM Canoe_RentDetails main
			INNER JOIN Canoe_IndividualCanoe sub ON main.IndCanoeID=sub.IndCanoeID	
			INNER JOIN Canoe_Model model ON sub.ModelNo = model.ModelID
			LEFT OUTER JOIN Canoe_Category cal ON cal.CID = model.CategoryID
			ORDER BY cal.CID, model.ModelID, main.IndCanoeID, main.ReturnDate
		End
	End
	RETURN
