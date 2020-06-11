USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_SMSTemplateGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_SMSTemplateGet] 

@param_sintSMSTemplateID	smallint = null,
@param_TemplateName			nvarchar(50) = null

AS
BEGIN

	SET NOCOUNT ON;

SELECT	SMSTemplateID, TemplateName, TemplateFor, [Message]
		FROM	[NavIntegrationDB].[dbo].[Switch_SMSTemplate] 
		WHERE	(SMSTemplateID = @param_sintSMSTemplateID 
				OR TemplateName = @param_TemplateName)

--IF EXISTS (SELECT SMSTemplateID FROM [NavIntegrationDB].[dbo].[Switch_SMSTemplate] WHERE SMSTemplateID = @param_sintSMSTemplateID AND TemplateName = @param_TemplateName)
--	BEGIN
--		SELECT	SMSTemplateID, TemplateName, TemplateFor, [Message]
--		FROM	[NavIntegrationDB].[dbo].[Switch_SMSTemplate] 
--		WHERE	SMSTemplateID = @param_sintSMSTemplateID 
--				AND TemplateName = @param_TemplateName
--	END
--ELSE
--	BEGIN
--		SELECT	SMSTemplateID, TemplateName, TemplateFor, [Message]
--		FROM	[NavIntegrationDB].[dbo].[Switch_SMSTemplate] 
--		WHERE	SMSTemplateID = @param_sintSMSTemplateID
--	END

END
GO
