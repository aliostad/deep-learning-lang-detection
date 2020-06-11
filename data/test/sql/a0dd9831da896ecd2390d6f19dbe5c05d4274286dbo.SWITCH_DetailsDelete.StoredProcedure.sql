USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_DetailsDelete]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_DetailsDelete]
	@param_intSwitchDetailsID	INT
     
AS
BEGIN
	
SET NOCOUNT ON;

DELETE FROM dbo.SwitchDetails
WHERE SwitchDetailsID = @param_intSwitchDetailsID
	
END
GO
