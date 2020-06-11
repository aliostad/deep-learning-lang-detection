USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHScheme_Delete]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHScheme_Delete] 

@param_SwitchID int

AS
BEGIN

	DELETE 
	FROM dbo.SwitchSchemeDetails
	WHERE SwitchID = @param_SwitchID;
	
	DELETE
	FROM dbo.SwitchSchemeHeader
	WHERE SwitchID = @param_SwitchID;

	DELETE
	FROM dbo.SwitchSchemeDetails_Client
	WHERE SwitchID = @param_SwitchID;

END
GO
