USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_FeeDelete]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_FeeDelete]

@param_intIFA_ID		INT

AS

BEGIN
	DELETE 
	FROM [NavIntegrationDB].[dbo].[SwitchFee] 
	WHERE IFA_ID = @param_intIFA_ID
END
GO
