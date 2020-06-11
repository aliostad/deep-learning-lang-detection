USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_EmailTemplateGetAll]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_EmailTemplateGetAll] 

AS
BEGIN

	SET NOCOUNT ON;

		SELECT	EmailTemplateID, TemplateName, Description, Body
		FROM dbo.Switch_EmailTemplate
END
GO
