USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelGroupInsertUpdate]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelGroupInsertUpdate]

 @param_IFA_ID INT,
 @param_ModelGroupID NVARCHAR(50),
 @param_ModelGroupName NVARCHAR(50)
 
 AS
 BEGIN
 
	 IF NOT EXISTS(SELECT * FROM NavIntegrationDB.dbo.ModelGroup WHERE ModelGroupID = @param_ModelGroupID AND IFA_ID = @param_IFA_ID) 
		BEGIN
			INSERT INTO NavIntegrationDB.dbo.ModelGroup (ModelGroupID, ModelGroupName, IFA_ID)
			VALUES (@param_ModelGroupID, @param_ModelGroupName, @param_IFA_ID)
		END
	 ELSE
		BEGIN
			IF (UPPER(RTRIM(LTRIM(@param_ModelGroupName))) <> (SELECT UPPER(RTRIM(LTRIM(ModelGroupName))) FROM NavIntegrationDB.dbo.ModelGroup WHERE ModelGroupID = @param_ModelGroupID AND IFA_ID = @param_IFA_ID))
			BEGIN
				UPDATE NavIntegrationDB.dbo.ModelGroup
					SET ModelGroupName = @param_ModelGroupName
				WHERE ModelGroupID = @param_ModelGroupID AND IFA_ID = @param_IFA_ID			
			END
		END
 END
GO
