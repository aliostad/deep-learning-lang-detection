USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioInsertUpdate]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioInsertUpdate]

@param_ModelPortfolioID		NVARCHAR(50),
@param_ModelGroupID			NVARCHAR(50),
@param_ModelPortfolioName	NVARCHAR(50),
@param_ModelPortfolioDesc	NVARCHAR(MAX)

AS
BEGIN
	IF NOT EXISTS (SELECT * FROM NavIntegrationDB.dbo.ModelPortfolio WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID)
		BEGIN
			INSERT INTO NavIntegrationDB.dbo.ModelPortfolio (ModelPortfolioID, ModelGroupID, ModelPortfolioName, ModelPortfolioDesc)
			VALUES (@param_ModelPortfolioID, @param_ModelGroupID, @param_ModelPortfolioName, @param_ModelPortfolioDesc)
		END
	ELSE
		BEGIN
			IF(UPPER(LTRIM(RTRIM(@param_ModelPortfolioName))) <> (SELECT UPPER(LTRIM(RTRIM(ModelPortfolioName))) FROM NavIntegrationDB.dbo.ModelPortfolio WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID))
			BEGIN
				UPDATE NavIntegrationDB.dbo.ModelPortfolio
				SET ModelPortfolioName = @param_ModelPortfolioName
				WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID
			END
		END
END
GO
