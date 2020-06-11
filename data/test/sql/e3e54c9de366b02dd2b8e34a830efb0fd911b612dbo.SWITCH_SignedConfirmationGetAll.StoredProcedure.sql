USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_SignedConfirmationGetAll]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_SignedConfirmationGetAll]

AS
BEGIN

 SET NOCOUNT ON;

   
 SELECT C.CompanyID, C.Company, NavIntegrationDB.dbo.IsCompanyInEmailSignedConfirmation(C.CompanyID) as 'IsRequired'
 FROM NavGlobalDBwwwGUID.dbo.Company C
 --WHERE UPPER(C.CompanyType) like 'INSURANCE%'
END
GO
