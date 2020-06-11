USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioSave]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from dbo.ModelPortfolio
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioSave]

@param_ModelPortfolioID		nvarchar(50),
@param_ModelGroupID			nvarchar(50),
@param_ModelPortfolioName	nvarchar(50),
@param_ModelPortfolioDesc	nvarchar(max) = null

AS

BEGIN
	IF EXISTS(SELECT ModelPortfolioID FROM [NavIntegrationDB].[dbo].[ModelPortfolio] WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID)
		BEGIN
			IF (UPPER(RTRIM(LTRIM(@param_ModelPortfolioName))) = (SELECT UPPER(RTRIM(LTRIM(ModelPortfolioName))) FROM [NavIntegrationDB].[dbo].[ModelPortfolio] WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID))
				BEGIN
					UPDATE [NavIntegrationDB].[dbo].[ModelPortfolio]
					   SET [ModelPortfolioName] = @param_ModelPortfolioName
					 WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID
				END
		END
	ELSE
		INSERT INTO [NavIntegrationDB].[dbo].[ModelPortfolio]
           ([ModelPortfolioID]
           ,[ModelGroupID]
           ,[ModelPortfolioName]
           ,[ModelPortfolioDesc]
           )
		 VALUES
			   (@param_ModelPortfolioID
			   ,@param_ModelGroupID
			   ,@param_ModelPortfolioName
			   ,(CASE WHEN @param_ModelPortfolioDesc = '' THEN NULL ELSE @param_ModelPortfolioDesc END)
			   )
END
GO
