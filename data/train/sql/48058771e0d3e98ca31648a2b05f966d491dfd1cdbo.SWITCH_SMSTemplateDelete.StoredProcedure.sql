USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_SMSTemplateDelete]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_SMSTemplateDelete] 

@param_sintSMSTemplateID	smallint

AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [NavIntegrationDB].[dbo].[Switch_SMSTemplate] WHERE SMSTemplateID = @param_sintSMSTemplateID

END
GO
