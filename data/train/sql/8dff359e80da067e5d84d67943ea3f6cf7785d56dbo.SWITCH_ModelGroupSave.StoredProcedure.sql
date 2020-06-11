USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelGroupSave]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelGroupSave]

@param_ModelGroupID		nvarchar(50),
@param_ModelGroupName	nvarchar(50),
@param_IFA_ID			int,
@param_ModelGroupCode	int

AS
BEGIN
	IF EXISTS(SELECT ModelGroupID FROM NavIntegrationDB.dbo.ModelGroup WHERE ModelGroupID = @param_ModelGroupID)
		BEGIN
			IF (UPPER(RTRIM(LTRIM(@param_ModelGroupName))) = (SELECT UPPER(RTRIM(LTRIM(ModelGroupName))) FROM NavIntegrationDB.dbo.ModelGroup WHERE ModelGroupID = @param_ModelGroupID AND IFA_ID = @param_IFA_ID AND ModelGroupCode = @param_ModelGroupCode))
				BEGIN
					UPDATE [NavIntegrationDB].[dbo].[ModelGroup]
					   SET [ModelGroupName] = @param_ModelGroupName
					 WHERE ModelGroupID = @param_ModelGroupID AND IFA_ID = @param_IFA_ID AND ModelGroupCode = @param_ModelGroupCode
				END
		END
	ELSE
		INSERT INTO [NavIntegrationDB].[dbo].[ModelGroup]
				   ([ModelGroupID]
				   ,[ModelGroupName]
				   ,[IFA_ID]
				   ,[ModelGroupCode])
			 VALUES
				   (@param_ModelGroupID
				   ,@param_ModelGroupName
				   ,@param_IFA_ID
				   ,@param_ModelGroupCode)
END
GO
