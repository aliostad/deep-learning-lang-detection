USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHSchemeclient_HeaderUpdate]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHSchemeclient_HeaderUpdate]

	@param_intSwitchID		INT
	,@param_intStatus		SMALLINT
	,@param_strDescription	NVARCHAR(MAX) = null
AS
BEGIN

SET NOCOUNT ON;

	UPDATE dbo.SwitchSchemeHeader
	SET [Amend_Status] = @param_intStatus,
		[Amend_Description] = @param_strDescription
	WHERE [SwitchID] = @param_intSwitchID;

END
GO
