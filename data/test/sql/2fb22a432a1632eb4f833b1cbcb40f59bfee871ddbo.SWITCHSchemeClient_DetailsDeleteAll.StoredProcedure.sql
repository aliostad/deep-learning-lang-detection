USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHSchemeClient_DetailsDeleteAll]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHSchemeClient_DetailsDeleteAll] 

@param_SwitchID int

AS
BEGIN

	DELETE
	FROM dbo.SwitchSchemeDetails_Client
	WHERE SwitchID = @param_SwitchID;


END
GO
