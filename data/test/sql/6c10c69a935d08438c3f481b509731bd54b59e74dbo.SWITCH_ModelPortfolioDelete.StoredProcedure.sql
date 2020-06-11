USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioDelete]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioDelete]   
  
@param_ModelGroupID		NVARCHAR(50),
@param_ModelPortfolioID	NVARCHAR(50)
  
AS  
BEGIN  
  
 DELETE   
 FROM ModelPortfolio  
 WHERE	ModelGroupID = @param_ModelGroupID
 AND	ModelPortfolioID = @param_ModelPortfolioID 
   
IF @@ERROR = 0
	BEGIN
		DELETE  
		 FROM	ModelPortfolioDetails  
		 WHERE	ModelGroupID = @param_ModelGroupID
		 AND	ModelPortfolioID = @param_ModelPortfolioID
	END
  
END
GO
