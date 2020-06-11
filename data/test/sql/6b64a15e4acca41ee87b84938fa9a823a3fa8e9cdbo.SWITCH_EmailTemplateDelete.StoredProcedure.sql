USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_EmailTemplateDelete]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_EmailTemplateDelete] 

@param_intEmailTemplateID	int

AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM dbo.Switch_EmailTemplate WHERE EmailTemplateID = @param_intEmailTemplateID;

END
GO
