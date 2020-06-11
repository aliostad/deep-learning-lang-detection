USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHSchemeHistory_MessageInsert]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHSchemeHistory_MessageInsert]

	@param_HistoryID		int
	,@param_Message		nvarchar(max)
	
AS
BEGIN

SET NOCOUNT ON;

INSERT INTO [NavIntegrationDB].[dbo].[SwitchSchemeHistoryMessages]
           ([HistoryID],[Message])
     VALUES
           (@param_HistoryID, @param_Message);
END
GO
