USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioClientGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioClientGet]

--@param_IFA_Code		NVARCHAR(50),
--@param_ModelGroup	NVARCHAR(50),
--@param_ModelName	NVARCHAR(50)
@param_IFA_ID			INT,
@param_ModelID			NVARCHAR(50),
@param_ModelPortfolioID	NVARCHAR(50),
@param_HasDiscretionary	BIT = 0
AS
BEGIN
	SELECT
	   mp.ClientID				AS ModelGroupID
	  ,mp.PortfolioID			AS ModelPortfolioID
	  ,mpgd.Surname				AS ModelIFA
	  ,mpgd.Forenames			AS ModelGroup
	  ,mp.AccountNumber			AS ModelName
	  ,c.ClientID				AS ClientID
	  ,cwd.Surname				AS ClientSurname
	  ,cwd.Forenames			AS ClientFornames
	  ,p.PortfolioID			AS ClientPortfolioID
	  ,co.Company				AS ClientPortfolioCompany
	  ,p.AccountNumber			AS ClientPortfolioAccountNumber
	  ,(CASE WHEN (ISNULL(p.MFPercent,0) = 0) THEN 0 ELSE 1 END) AS Discretionary
	  ,(CASE WHEN (sh.PortfolioID IS NULL) THEN 0 ELSE 1 END) AS SwitchTemp
	  ,ISNULL(s.SwitchID,0)		AS SwitchID
	  
	FROM		NavGlobalDBwwwGUID.dbo.Portfolio AS mp							-- Model Portfolio
	INNER JOIN	NavGlobalDBwwwGUID.dbo.Client AS mpg							-- Model Portfolio Group
		ON		mpg.ClientID = mp.ClientID
		AND		mpg.IFA_ID = 210												-- all Model Portfolios are linked to the IFA_ID 210 
	LEFT JOIN	NavGlobalDBwwwGUID.dbo.ClientWebDetails AS mpgd
		ON		mpgd.ClientID = mpg.ClientID
	INNER JOIN	NavGlobalDBwwwGUID.dbo.IFA AS mpi								-- the actual IFA that owns the model is found from the 
		ON		mpi.IFA_Code = mpgd.Surname										-- code stored in the Surname field on the Model Portfolio Group
	INNER JOIN	NavGlobalDBwwwGUID.dbo.Portfolio AS p							-- The link between the Model Portfolio and the Client's portfolio is via the
		ON		p.CustodialPolicyID = mp.PortfolioID							-- CustodialPolicyID field.
	INNER JOIN	NavGlobalDBwwwGUID.dbo.Company AS co
		ON		co.CompanyID = p.Company
	INNER JOIN	NavGlobalDBwwwGUID.dbo.Client AS c								-- The Client Owning the linked policy
		ON		c.ClientID = p.ClientID
		AND		c.IFA_ID = mpi.IFA_ID											-- cross check that the Client's IFA is the same as the owner of the Model Portfolio Group.
	INNER JOIN	NavGlobalDBwwwGUID.dbo.ClientWebDetails as cwd
		ON		cwd.ClientID = c.ClientID
	LEFT JOIN	NavIntegrationDB.dbo.SwitchHeaderTemp as sh
		ON		sh.ClientID = p.ClientID
		AND		sh.PortfolioID = p.PortfolioID
	LEFT JOIN	NavIntegrationDB.dbo.SwitchHeader as s
		ON		s.ClientID = p.ClientID
		AND		s.PortfolioID = p.PortfolioID
	WHERE		NOT EXISTS
				(SELECT ClientID, PortfolioID FROM NavIntegrationDB.dbo.SwitchHeader a where a.ClientID = c.ClientID AND a.PortfolioID =  p.PortfolioID AND a.Status = 6
					UNION
				 SELECT ClientID, PortfolioID FROM NavIntegrationDB.dbo.SwitchHeader a where a.ClientID = c.ClientID AND a.PortfolioID = p.PortfolioID AND a.ModelGroupID = mp.ClientID AND a.ModelPortfolioID = mp.PortfolioID)	
	AND			EXISTS(SELECT DISTINCT ClientID, PortfolioID FROM NavGlobalDBwwwGUID.dbo.PortfolioData a WHERE a.ClientID = c.ClientID AND a.PortfolioID = p.PortfolioID)				 
	AND			mpgd.ClientNumber = @param_IFA_ID
	AND			mp.ClientID = @param_ModelID
	AND			mp.PortfolioID = @param_ModelPortfolioID
	--AND			(@param_HasDiscretionary = 1 AND p.MFPercent in (1, -1))
	--OR			(@param_HasDiscretionary = 0 AND ISNULL(p.MFPercent, 0) = 0)
END
GO
