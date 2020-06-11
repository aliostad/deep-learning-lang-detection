USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_SMSTemplateInsert]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_SMSTemplateInsert] 
	@param_TemplateName nvarchar(50),
	@param_TemplateFor	nvarchar(50),
	@param_Message		nvarchar(160)

AS
BEGIN

	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT SMSTemplateID, TemplateName, TemplateFor, [Message] FROM [NavIntegrationDB].[dbo].[Switch_SMSTemplate] WHERE TemplateName = @param_TemplateName)
		BEGIN
			INSERT INTO [NavIntegrationDB].[dbo].[Switch_SMSTemplate]
			(TemplateName, TemplateFor, [Message])
			VALUES
			(@param_TemplateName, @param_TemplateFor, @param_Message)
		END	
	ELSE
		BEGIN
			RAISERROR('Template name already exists.', 16, 1)		
		END
END
GO
