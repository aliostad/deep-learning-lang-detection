USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelGroupGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelGroupGet]

@param_ModelGroupID NVARCHAR(50),
@param_IFA_ID INT

AS

BEGIN
	SELECT
		  c.ClientID
		 ,Forenames
		 ,ClientNumber
		 ,c.IFA_ID 
	FROM		NavGlobalDBwwwGUID.dbo.Client AS c 
	INNER JOIN	NavGlobalDBwwwGUID.dbo.ClientWebNames AS cw ON c.ClientID = cw.ClientID 
	WHERE		c.IFA_ID = 210 
	AND			c.ClientNumber = @param_IFA_ID 
	AND			c.ClientID = @param_ModelGroupID
	
END
GO
