USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHclient_DetailsDelete]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHclient_DetailsDelete]
	@param_intSwitchDetailsID	INT
     
AS
BEGIN
	
SET NOCOUNT ON;

DELETE FROM dbo.SwitchDetails_Client
WHERE SwitchDetailsID = @param_intSwitchDetailsID
	
END
GO
