USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHScheme_DetailsDeleteAll]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHScheme_DetailsDeleteAll] 

@param_SwitchID int

AS
BEGIN

	DELETE 
	FROM dbo.SwitchSchemeDetails
	WHERE SwitchID = @param_SwitchID;


END
GO
