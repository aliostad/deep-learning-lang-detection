USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_Temp_HeaderGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_Temp_HeaderGet] 

@param_intIFA_ID		int,
@param_ModelGroupID		nvarchar(50) = NULL,
@param_ModelPortfolioID	nvarchar(50) = NULL,
@param_strClientID		nvarchar(50) = NULL,
@param_strPortfolioID	nvarchar(50) = NULL

AS

BEGIN

	SET NOCOUNT ON;
	BEGIN
		SELECT	 IFA_ID
				,ModelGroupID
				,ModelPortfolioID
				,ClientID
				,PortfolioID
				,Date_Created
				,Created_By
				,Date_Updated
				,Updated_By
				,[Description]
				,[IsModelCustomized]				
		FROM	[NavIntegrationDB].[dbo].[SwitchHeaderTemp]
		WHERE	IFA_ID = @param_intIFA_ID
		AND		ModelGroupID = @param_ModelGroupID
		AND		ModelPortfolioID = @param_ModelPortfolioID
		AND		ClientID = @param_strClientID
		AND		PortfolioID = @param_strPortfolioID
	END
END
GO
