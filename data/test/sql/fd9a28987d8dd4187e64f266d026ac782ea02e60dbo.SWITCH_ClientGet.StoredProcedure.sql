USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ClientGet]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ClientGet]

@param_ClientID	NVARCHAR(50)

AS
BEGIN

	SELECT 
		 C.ClientID
		,CWD.Surname
		,CWD.Forenames
		,C.Salesperson
		,C.ServicingOffice
		,C.Country
		,C.ValuationFrequency
		,C.ClientNumber
		,C.Category
		,C.Currency
		,C.HTML
		,C.Code
		,C.IFA_ID
		,C.OLDeleted
		,C.ManagerID
		,C.RegionID
		,C.AgentID
		,C.CreatedBy
		,C.AdministratorID
		,C.CoordinatorID
		,C.Language
		--,CONVERT(VARCHAR(10),C.IFAUpdatedDate,101) AS IFAUpdatedDate
		,C.IFAUpdatedDate
		,C.IFAUpdatedBy
		,CWD.WorkEmail
		,CWD.PersonalEmail
	FROM NavGlobalDBwwwGUID.dbo.Client C
	INNER JOIN NavGlobalDBwwwGUID.dbo.ClientWebDetails CWD on CWD.ClientID = C.ClientID
	WHERE C.ClientID = @param_ClientID

END
GO
