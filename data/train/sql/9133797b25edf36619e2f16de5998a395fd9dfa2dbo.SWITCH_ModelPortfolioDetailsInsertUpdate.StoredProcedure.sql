USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioDetailsInsertUpdate]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioDetailsInsertUpdate]

@param_IFA_ID				INT,
@param_ModelPortfolioID		NVARCHAR(50),
@param_ModelGroupID			NVARCHAR(50),
@param_FundID				INT,
@param_Allocation			FLOAT,
@param_IsDeletable			SMALLINT

AS
BEGIN
	IF NOT EXISTS (SELECT ModelGroupID, ModelPortfolioID, FundID FROM NavIntegrationDB.dbo.ModelPortfolioDetails WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID AND FundID = @param_FundID)
		BEGIN
			INSERT INTO NavIntegrationDB.dbo.ModelPortfolioDetails (IFA_ID, ModelPortfolioID, ModelGroupID, FundID, Allocation, isDeletable)
			VALUES (@param_IFA_ID, @param_ModelPortfolioID, @param_ModelGroupID, @param_FundID, @param_Allocation, @param_IsDeletable)
		END
	ELSE
		BEGIN
			IF(@param_Allocation <> (SELECT Allocation FROM NavIntegrationDB.dbo.ModelPortfolioDetails WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID AND FundID = @param_FundID))
			BEGIN
				UPDATE NavIntegrationDB.dbo.ModelPortfolioDetails
				SET Allocation = @param_Allocation
				WHERE ModelGroupID = @param_ModelGroupID AND ModelPortfolioID = @param_ModelPortfolioID AND FundID = @param_FundID
			END
		END
END
GO
