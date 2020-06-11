USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_HeaderUpdate]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_HeaderUpdate] 

@param_intSwitchID int,
@param_Status smallint,
@param_Description nvarchar(max) = null

AS
BEGIN

	SET NOCOUNT ON;
	
	IF @param_Description = null Begin

		UPDATE SwitchHeader
		SET [Status] = @param_Status, SecurityCodeAttempt = 0
		WHERE [SwitchID] = @param_intSwitchID

	END
	ELSE Begin
		UPDATE SwitchHeader
		SET [Status] = @param_Status, Description = @param_Description, SecurityCodeAttempt = 0
		WHERE [SwitchID] = @param_intSwitchID
	END 
	
END
GO
