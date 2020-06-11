USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_DetailsGet]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_DetailsGet] 

@param_intSwitchID int

AS
BEGIN

	SET NOCOUNT ON;
	
	select  SwitchDetailsID
      ,SwitchID
      ,FundID
      ,Allocation
      ,Date_Created
      ,Created_By
      ,Date_LastUpdate
      ,Updated_By
	  ,isDeletable
  FROM SwitchDetails
  WHERE SwitchID = @param_intSwitchID

END
GO
