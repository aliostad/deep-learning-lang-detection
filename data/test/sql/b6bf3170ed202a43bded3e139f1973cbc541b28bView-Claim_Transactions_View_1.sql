IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Claim_Transactions_View_1]'))
DROP VIEW [dbo].[Claim_Transactions_View_1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Claim_Transactions_View_1]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW dbo.Claim_Transactions_View_1
AS
SELECT     dbo.Claim_Transaction_View_1.transnumber, dbo.Claim_Transaction_View_1.transtypecode, dbo.Claim_Transaction_View_1.claimnumber, 
                      dbo.Claim_Transaction_View_1.claimantseq, dbo.Claim_Transaction_View_1.policytypecode, dbo.Claim_Transaction_View_1.losstypecode, 
                      dbo.Claim_Transaction_View_1.idmdccanoind, dbo.Claim_Transaction_View_1.acctngyear, dbo.Claim_Transaction_View_1.acctngmonth, 
                      dbo.Claim_Transaction_View_1.transamt, dbo.Claim_Transaction_View_1.dcind, dbo.Claim_Transaction_View_1.transdate, 
                      dbo.Claim_Transaction_View_1.lossdate, dbo.Claim_Transaction_View_1.claimcompanycode, dbo.Claim_Transaction_View_1.claimreportdate, 
                      dbo.Claim_Transaction_View_1.CAT_EventID, dbo.Claim_Transaction_View_1.examinerpid, dbo.Claim_Transaction_View_1.coveragecode, 
                      dbo.Claim_Transaction_View_1.numericsignmultiplier, dbo.Claim_Transaction_View_1.losscauseid, dbo.Claim_Transaction_View_1.ltgind, 
                      dbo.Claim_Transaction_View_1.statecode, dbo.Claim_Transaction_View_1.accidentstatecode, dbo.Claim_Transaction_View_1.losssubtypecode, 
                      dbo.Claim_Transaction_View_1.transtypedesc, dbo.Claim_Transaction_View_1.transtypecat, dbo.Claim_Transaction_View_1.riskcode, 
                      dbo.Claim_Transaction_View_1.policynumber, dbo.Claim_Transaction_View_1.accountnumber, dbo.Claim_Transaction_View_1.transamtsigned, 
                      dbo.Claim_Transaction_View_1.TranstypeGroup, (CASE WHEN transtypegroup = ''Loss Payment'' THEN transamtsigned ELSE 0 END) AS paid, 
                      (CASE WHEN transtypegroup = ''Loss Reserve'' THEN SUM(transamtsigned) ELSE 0 END) AS Reserve, 
                      (CASE WHEN transtypegroup = ''Salvage'' THEN SUM(transamtsigned) ELSE 0 END) AS Salvage, 
                      (CASE WHEN transtypegroup = ''Subrogation'' THEN SUM(transamtsigned) ELSE 0 END) AS Subrogation, 
                      (CASE WHEN transtypegroup = ''Deductible Return'' THEN SUM(transamtsigned) ELSE 0 END) AS Deductible_Return, 
                      (CASE WHEN transtypegroup = ''Return'' THEN SUM(transamtsigned) ELSE 0 END) AS Return_Amt, 
                      (CASE WHEN transtypegroup = ''None'' THEN SUM(transamtsigned) ELSE 0 END) AS None_Amt, 
                      dbo.Claim_Transaction_View_1.acctngyear * 100 + dbo.Claim_Transaction_View_1.acctngmonth AS acctngyearmonth, 
                      YEAR(dbo.Claim_Transaction_View_1.lossdate) AS AccidentYear, dbo.Claim_Transaction_View_1.companycode, 
                      dbo.Claim_Transaction_View_1.effectivedate, dbo.Claim_Transaction_View_1.productcode, dbo.Claim_Transaction_View_1.BusinessClassID, 
                      dbo.Claim_Transaction_View_1.programcode, dbo.Claim_Transaction_View_1.EffectiveYearMonth, dbo.Claim_Transaction_View_1.EffectiveYear
FROM         dbo.Claim_Transaction_View_1 RIGHT OUTER JOIN
                      dbo.Individual_Accounts_for_Reports_View_1 ON 
                      dbo.Claim_Transaction_View_1.policynumber = dbo.Individual_Accounts_for_Reports_View_1.policynumber AND 
                      dbo.Claim_Transaction_View_1.accountnumber = dbo.Individual_Accounts_for_Reports_View_1.accountnumber
GROUP BY dbo.Claim_Transaction_View_1.transnumber, dbo.Claim_Transaction_View_1.transtypecode, dbo.Claim_Transaction_View_1.claimnumber, 
                      dbo.Claim_Transaction_View_1.claimantseq, dbo.Claim_Transaction_View_1.policytypecode, dbo.Claim_Transaction_View_1.losstypecode, 
                      dbo.Claim_Transaction_View_1.idmdccanoind, dbo.Claim_Transaction_View_1.acctngyear, dbo.Claim_Transaction_View_1.acctngmonth, 
                      dbo.Claim_Transaction_View_1.transamt, dbo.Claim_Transaction_View_1.dcind, dbo.Claim_Transaction_View_1.transdate, 
                      dbo.Claim_Transaction_View_1.lossdate, dbo.Claim_Transaction_View_1.claimcompanycode, dbo.Claim_Transaction_View_1.claimreportdate, 
                      dbo.Claim_Transaction_View_1.CAT_EventID, dbo.Claim_Transaction_View_1.examinerpid, dbo.Claim_Transaction_View_1.coveragecode, 
                      dbo.Claim_Transaction_View_1.numericsignmultiplier, dbo.Claim_Transaction_View_1.losscauseid, dbo.Claim_Transaction_View_1.ltgind, 
                      dbo.Claim_Transaction_View_1.statecode, dbo.Claim_Transaction_View_1.accidentstatecode, dbo.Claim_Transaction_View_1.losssubtypecode, 
                      dbo.Claim_Transaction_View_1.transtypedesc, dbo.Claim_Transaction_View_1.transtypecat, dbo.Claim_Transaction_View_1.riskcode, 
                      dbo.Claim_Transaction_View_1.policynumber, dbo.Claim_Transaction_View_1.accountnumber, dbo.Claim_Transaction_View_1.transamtsigned, 
                      dbo.Claim_Transaction_View_1.TranstypeGroup, dbo.Claim_Transaction_View_1.acctngyear * 100 + dbo.Claim_Transaction_View_1.acctngmonth, 
                      dbo.Claim_Transaction_View_1.companycode, dbo.Claim_Transaction_View_1.effectivedate, dbo.Claim_Transaction_View_1.productcode, 
                      dbo.Claim_Transaction_View_1.BusinessClassID, dbo.Claim_Transaction_View_1.programcode, dbo.Claim_Transaction_View_1.EffectiveYearMonth, 
                      dbo.Claim_Transaction_View_1.EffectiveYear
' 
GO
