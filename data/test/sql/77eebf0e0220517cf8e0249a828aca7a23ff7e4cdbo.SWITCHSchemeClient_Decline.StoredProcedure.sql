USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHSchemeClient_Decline]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHSchemeClient_Decline] 

@param_SwitchID int

AS
BEGIN

	UPDATE dbo.SwitchSchemeHeader
	SET [Status] = 5
	WHERE [SwitchID] = @param_SwitchID

END
GO
