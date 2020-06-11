USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCHScheme_GenerateCodeInsert]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCHScheme_GenerateCodeInsert]

	  @param_Code			NVARCHAR(16)
	 ,@param_SwitchID		INT 
	 ,@param_ClientID		NVARCHAR(20)
	 ,@param_SchemeID		NVARCHAR(50)
AS
BEGIN
	DECLARE @return_Valid int

SET NOCOUNT ON;
IF NOT EXISTS (SELECT [Code]  FROM [NavIntegrationDB].[dbo].[SwitchGenerateCode] WHERE [Code] = @param_Code)
 BEGIN
	INSERT INTO [NavIntegrationDB].[dbo].[SwitchGenerateCode]
		([Code])
	 VALUES
		(@param_Code);
		
	 IF ((SELECT COUNT(*) FROM  [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode] WHERE SwitchID = @param_SwitchID and ClientID = @param_ClientID and SchemeID = @param_SchemeID) > 0)
		BEGIN
			DELETE FROM [NavIntegrationDB].[dbo].[SwitchGenerateCode] WHERE Code = 
				(SELECT Code FROM [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode] WHERE SwitchID = @param_SwitchID and ClientID = @param_ClientID and SchemeID = @param_SchemeID)
			UPDATE [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode]
				SET Code = @param_Code, IsConsumed = 0 
			WHERE SwitchID = @param_SwitchID and ClientID = @param_ClientID and SchemeID = @param_SchemeID
		END
	  ELSE 
		BEGIN
			INSERT INTO [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode]
				(Code, SwitchID, ClientID, SchemeID)
			VALUES
				(@param_Code, @param_SwitchID, @param_ClientID, @param_SchemeID)
		END


		SET @return_Valid = 1
	END

ELSE IF EXISTS (SELECT [Code] FROM [NavIntegrationDB].[dbo].[SwitchGenerateCode] WHERE DATEDIFF(dd,DateCreated,GETDATE())  > 30 AND [Code] = @param_Code)
	BEGIN
		UPDATE [NavIntegrationDB].[dbo].[SwitchGenerateCode]
			SET DateCreated = GETDATE()
			WHERE Code = @param_Code
		IF ((SELECT COUNT(*) FROM  [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode] WHERE SwitchID = @param_SwitchID and ClientID = @param_ClientID and SchemeID = @param_SchemeID) > 0)
		BEGIN
			DELETE FROM [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode] WHERE Code = 
				(SELECT Code FROM [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode] WHERE SwitchID = @param_SwitchID and ClientID = @param_ClientID and SchemeID = @param_SchemeID)
			UPDATE [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode]
				SET Code = @param_Code, IsConsumed = 0
			WHERE SwitchID = @param_SwitchID and ClientID = @param_ClientID and SchemeID = @param_SchemeID
		END
	  ELSE 
		BEGIN
			INSERT INTO [NavIntegrationDB].[dbo].[SwitchSchemeClientSecurityCode]
				(Code, SwitchID, ClientID, SchemeID)
			VALUES
				(@param_Code, @param_SwitchID, @param_ClientID, @param_SchemeID)
		END

		SET @return_Valid = 1
	END
SELECT ISNULL(@return_Valid,0)
END
GO
