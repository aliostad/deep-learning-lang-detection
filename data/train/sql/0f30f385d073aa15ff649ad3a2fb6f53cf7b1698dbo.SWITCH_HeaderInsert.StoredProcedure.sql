USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_HeaderInsert]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_HeaderInsert]

	 @param_strPortfolioID	NVARCHAR(50)
	,@param_strClientID		NVARCHAR(50)
	,@param_intStatus		SMALLINT
	,@param_strCreated_By	NVARCHAR(50)
	,@param_intSwitchID		INT				= NULL
	,@param_strDescription	NVARCHAR(MAX)
	,@param_strModelGroupID	NVARCHAR(50) = NULL
	,@param_strModelPortfolioID	NVARCHAR(50) = NULL
	
AS
BEGIN

SET NOCOUNT ON;



--IF NOT EXISTS (SELECT PortfolioID FROM [NavIntegrationDB].[dbo].[SwitchHeader] WHERE PortfolioID=@param_strPortfolioID AND [Status] = 0)
--IF @param_intSwitchID = NULL
IF NOT EXISTS (SELECT PortfolioID FROM [NavIntegrationDB].[dbo].[SwitchHeader] WHERE [SwitchID] = @param_intSwitchID)
BEGIN
	--RAISERROR('Switch details already exists!', 16, 1) 
	INSERT INTO [NavIntegrationDB].[dbo].[SwitchHeader]
		   ([PortfolioID]
		   ,[ClientID]
		   ,[Status]
		   ,[Date_Created]
		   ,[Created_By]
		   ,[Description] 
		   ,[ModelGroupID]
		   ,[ModelPortfolioID] 
		   )
	 VALUES
		   (@param_strPortfolioID
		   ,@param_strClientID
		   ,@param_intStatus
		   ,CURRENT_TIMESTAMP
		   ,@param_strCreated_By
		   ,@param_strDescription
		   ,@param_strModelGroupID
		   ,@param_strModelPortfolioID
		   );
		   
	SELECT @@IDENTITY 
END
ELSE
BEGIN
	IF(LEN(@param_strDescription) = 0)
		BEGIN
			UPDATE [NavIntegrationDB].[dbo].[SwitchHeader]
			SET [Status] = @param_intStatus, Date_Updated = CURRENT_TIMESTAMP, Updated_By = @param_strCreated_By, [SecurityCodeAttempt] = 0, [ModelGroupID] = @param_strModelGroupID, [ModelPortfolioID] = @param_strModelPortfolioID
			WHERE [SwitchID] = @param_intSwitchID;		
		END
	ELSE
		BEGIN
			UPDATE [NavIntegrationDB].[dbo].[SwitchHeader]
			SET [Status] = @param_intStatus, Date_Updated = CURRENT_TIMESTAMP, Updated_By = @param_strCreated_By, [SecurityCodeAttempt] = 0, [ModelGroupID] = @param_strModelGroupID, [ModelPortfolioID] = @param_strModelPortfolioID
			WHERE [SwitchID] = @param_intSwitchID;
		END
	
	SELECT @param_intSwitchID

END
END
GO
