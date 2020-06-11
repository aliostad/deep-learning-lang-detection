USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHHistory_MessageInsert]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHHistory_MessageInsert]

	@param_HistoryID		int
	,@param_Message		nvarchar(max)
	
AS
BEGIN

SET NOCOUNT ON;

INSERT INTO [NavIntegrationDB].[dbo].[SwitchHistoryMessages]
           ([HistoryID],[Message])
     VALUES
           (@param_HistoryID, @param_Message);
END
GO
