USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHclient_Decline]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHclient_Decline] 

@param_SwitchID int

AS
BEGIN

	UPDATE dbo.SwitchHeader
	SET [Status] = 5
	WHERE [SwitchID] = @param_SwitchID

END
GO
