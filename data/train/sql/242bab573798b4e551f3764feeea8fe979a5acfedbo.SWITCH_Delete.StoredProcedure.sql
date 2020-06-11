USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_Delete]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_Delete] 

@param_SwitchID int

AS
BEGIN

	DELETE 
	FROM SwitchDetails
	WHERE SwitchID = @param_SwitchID;
	
	DELETE
	FROM SwitchHeader
	WHERE SwitchID = @param_SwitchID;

END
GO
