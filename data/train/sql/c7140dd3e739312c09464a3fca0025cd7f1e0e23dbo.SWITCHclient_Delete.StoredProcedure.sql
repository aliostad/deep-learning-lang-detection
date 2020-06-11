USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHclient_Delete]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHclient_Delete] 

@param_SwitchID int

AS
BEGIN

	DELETE 
	FROM dbo.SwitchDetails_Client
	WHERE SwitchID = @param_SwitchID;
	
	UPDATE [NavIntegrationDB].[dbo].[SwitchHeader]
	SET [Amend_Status] = null,
		[Amend_Description] = null
	WHERE [SwitchID] = @param_SwitchID;

END
GO
