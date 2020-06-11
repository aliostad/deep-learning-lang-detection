USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_SMSTemplateGetAll]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_SMSTemplateGetAll] 

AS
BEGIN

	SET NOCOUNT ON;

		SELECT	SMSTemplateID, TemplateName, TemplateFor, [Message]
		FROM	[NavIntegrationDB].[dbo].[Switch_SMSTemplate]		
END
GO
