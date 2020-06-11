--SELECT d.xmldata.query('/root/product[@id="304"]/name') FROM dbo.ExtraData d


--UPDATE 
--dbo.ExtraData SET xmldata = Data
--WHERE Data LIKE '<%'
--AND Stamp > '1/1/13'

CREATE FUNCTION [dbo].[Registrations] ( @days INT )
RETURNS TABLE 
AS
RETURN 
(
SELECT 
	 tt.Id
	,tt.Stamp
	,o.OrganizationId 
	,o.OrganizationName 
	,pu.PeopleId
	,pu.Name
	,ISNULL(xdata.value('(/OnlineRegModel/List/OnlineRegPersonModel)[1]/dob[1]', 'varchar(50)'),
		xdata.value('(/OnlineRegModel/List/OnlineRegPersonModel)[1]/DateOfBirth[1]', 'varchar(50)')) [dob]
	,ISNULL(xdata.value('(/OnlineRegModel/List/OnlineRegPersonModel)[1]/first[1]', 'varchar(50)'),
		xdata.value('(/OnlineRegModel/List/OnlineRegPersonModel)[1]/FirstName[1]', 'varchar(50)')) [first]
	,ISNULL(xdata.value('(/OnlineRegModel/List/OnlineRegPersonModel)[1]/last[1]', 'varchar(50)'),
		xdata.value('(/OnlineRegModel/List/OnlineRegPersonModel)[1]/LastName[1]', 'varchar(50)')) [last]
	,xdata.value('count(/OnlineRegModel/List/OnlineRegPersonModel)', 'int') cnt
	,tt.completed
FROM 
(
	SELECT 
		Id
		, Data
		, CONVERT(XML, Data) xdata
		, d.Stamp
		, d.completed
	FROM dbo.ExtraData d
	WHERE Stamp > DATEADD(dd, -@days, GETDATE())
	AND Data LIKE '%<OnlineRegModel>%'
) tt
LEFT JOIN dbo.Organizations o ON  xdata.value('(/OnlineRegModel/List/OnlineRegPersonModel)[1]/orgid[1]', 'int') = o.OrganizationId
LEFT JOIN dbo.People pu ON xdata.value('(/OnlineRegModel/UserPeopleId)[1]', 'int') = pu.PeopleId
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
