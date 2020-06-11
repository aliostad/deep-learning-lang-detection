
/****** Object: View [BasicInfo].[UserView] Script Date: 3/6/2014 5:24:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [BasicInfo].[UserView]    Script Date: 3/6/2014 10:59:17 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[UserView]'))
DROP VIEW [BasicInfo].[UserView]
GO

CREATE VIEW [BasicInfo].[UserView] AS 
SELECT   BasicInfo.CompanyView.Id * 100 + dbo.Users.Id AS Id, 
		dbo.Users.Id AS IdentityId, 
		dbo.Users.LastName + ', ' + dbo.Users.FirstName AS Name, 
        BasicInfo.CompanyView.Id AS CompanyId
FROM      dbo.Users CROSS JOIN
                BasicInfo.CompanyView