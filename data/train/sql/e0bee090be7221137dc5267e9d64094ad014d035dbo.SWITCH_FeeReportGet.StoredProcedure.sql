USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_FeeReportGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_FeeReportGet]

@param_intIFA_ID	INT,
@param_StartDate	NVARCHAR(10),
@param_EndDate		NVARCHAR(10)

AS
BEGIN
	SELECT 
	--Create Open XML to Select all SwitchID belongs to Per Switch Fee
	stuff((SELECT ',' + CONVERT(VARCHAR(3),a.SwitchID) FROM NavIntegrationDB.dbo.SwitchHeader a 
		INNER JOIN NavGlobalDBwwwGUID.dbo.Client AS C ON C.ClientID=a.ClientID
		INNER JOIN NavGlobalDBwwwGUID.dbo.IFA AS I ON I.IFA_ID=C.IFA_ID
		INNER JOIN (
		SELECT 
			a.IFA_ID,
			a.Annual_Fee,
			a.Per_Switch_Fee,
			CONVERT(VARCHAR(19),a.Date_Effectivity,121) AS Start_Date_Effective,
			CONVERT(VARCHAR(19),(DATEADD(SECOND,-1,
													(ISNULL((SELECT TOP 1 b.Date_Effectivity FROM
																							(SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Updated AS Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFee
																							UNION
																							SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFeeHistory) AS b 
															WHERE b.IFA_ID = a.IFA_ID and b.Date_Effectivity > a.Date_Effectivity ORDER BY b.Date_Effectivity ASC), 
													GETDATE())))),
			121) AS End_Date_Effective
		FROM
			(
			SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Updated AS Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFee
			UNION
			SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFeeHistory
			) AS a ) y ON	--ISNULL(a.Date_Updated, a.Date_Created) 
							a.Date_Created
							BETWEEN y.Start_Date_Effective AND y.End_Date_Effective AND y.IFA_ID=I.IFA_ID AND y.Per_Switch_Fee=TBLFEE.Per_Switch_Fee 
							WHERE a.Status = 6 AND (CONVERT(VARCHAR(10),a.Date_Created,105) >= @param_StartDate OR @param_StartDate = '') AND (CONVERT(VARCHAR(10),a.Date_Created,105) <= @param_EndDate OR @param_EndDate = '' )
									 ORDER BY SwitchID
									   FOR XML PATH('')
									),1,1,'')  as [Switches],
	-----------------------------------------------------------------------------------------------
		 I.IFA_ID
		,I.IFA_Name
		,TBLFEE.Per_Switch_Fee
		,COUNT(SH.SwitchID) AS Quantity
		,(SELECT MIN(Date_Created) AS StartDate FROM NavIntegrationDB.dbo.SwitchHeader a INNER JOIN NavGlobalDBwwwGUID.dbo.Client b ON a.ClientID=b.ClientID WHERE b.IFA_ID = C.IFA_ID) AS StartDate
		,(SELECT MAX(Date_Created) AS StartDate FROM NavIntegrationDB.dbo.SwitchHeader a INNER JOIN NavGlobalDBwwwGUID.dbo.Client b ON a.ClientID=b.ClientID WHERE b.IFA_ID = C.IFA_ID) AS EndDate
		--,(SELECT MIN(ISNULL(Date_Updated, Date_Created)) AS StartDate FROM NavIntegrationDB.dbo.SwitchHeader a INNER JOIN NavGlobalDBwwwGUID.dbo.Client b ON a.ClientID=b.ClientID WHERE b.IFA_ID = C.IFA_ID) AS StartDate
		--,(SELECT MAX(ISNULL(Date_Updated, Date_Created)) AS StartDate FROM NavIntegrationDB.dbo.SwitchHeader a INNER JOIN NavGlobalDBwwwGUID.dbo.Client b ON a.ClientID=b.ClientID WHERE b.IFA_ID = C.IFA_ID) AS EndDate
		,SH.Status
		
	FROM NavIntegrationDB.dbo.SwitchHeader SH
	INNER JOIN NavGlobalDBwwwGUID.dbo.Client AS C ON C.ClientID=SH.ClientID
	INNER JOIN NavGlobalDBwwwGUID.dbo.IFA AS I ON I.IFA_ID=C.IFA_ID
	INNER JOIN (
	SELECT 
		a.IFA_ID,
		a.Annual_Fee,
		a.Per_Switch_Fee,
		CONVERT(VARCHAR(19),a.Date_Effectivity,121) AS Start_Date_Effective,
		CONVERT(VARCHAR(19),(DATEADD(SECOND,-1,
												(ISNULL((SELECT TOP 1 b.Date_Effectivity FROM
																						(SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Updated AS Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFee
																						UNION
																						SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFeeHistory) AS b 
														WHERE b.IFA_ID = a.IFA_ID and b.Date_Effectivity > a.Date_Effectivity ORDER BY b.Date_Effectivity ASC), 
												GETDATE())))),
		121) AS End_Date_Effective
	FROM
		(
		SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Updated AS Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFee
		UNION
		SELECT IFA_ID, Annual_Fee, Per_Switch_Fee, Date_Effectivity FROM NavIntegrationDB.dbo.SwitchFeeHistory
		) AS a ) TBLFEE ON TBLFEE.IFA_ID = I.IFA_ID
	WHERE 
		SH.Status = 6
	AND 
		--ISNULL(SH.Date_Updated, SH.Date_Created)
		SH.Date_Created
		BETWEEN TBLFEE.Start_Date_Effective AND TBLFEE.End_Date_Effective
	AND (CONVERT(VARCHAR(10),SH.Date_Created,105) >= @param_StartDate OR @param_StartDate = '')
	AND (CONVERT(VARCHAR(10),SH.Date_Created,105) <= @param_EndDate OR @param_EndDate = '' )
	AND C.IFA_ID = @param_intIFA_ID
	GROUP BY  I.IFA_ID, I.IFA_Name, TBLFEE.Per_Switch_Fee, SH.Status, C.IFA_ID
	--SELECT 
	--	 Switches
	--	,IFA_ID
	--	,IFA_Name
	--	,Per_Switch_Fee 
	--	,Quantity
	--	,StartDate 
	--	,EndDate 
	--	,Status 
	--FROM [NavIntegrationDB].[dbo].[PerSwitchFeeReport]
	--WHERE (IFA_ID = @param_intIFA_ID OR @param_intIFA_ID = 0)
END
GO
