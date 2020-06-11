 
-- To Be Run as SA

--Use Master 
--GRANT VIEW ANY DEFINITION TO automation

-- Automation user should have Dataread, DataWrite?, Execute

declare @dbName nvarchar(1000)
select @dbName = db_name(db_id())

GRANT IMPERSONATE ON USER:: WebReadRegion TO automation
GRANT IMPERSONATE ON USER:: WebUserRegion TO automation

 if (@dbName = 'WebDB')
BEGIN
	GRANT IMPERSONATE ON USER:: WebUserUS TO automation
	GRANT IMPERSONATE ON USER:: WebUserMX TO automation
	GRANT IMPERSONATE ON USER:: WebUserUK TO automation
	GRANT IMPERSONATE ON USER:: WebUserUSMX TO automation
	GRANT IMPERSONATE ON USER:: WebUserFRCA TO automation
	GRANT IMPERSONATE ON USER:: WebReadRegion TO automation
	GRANT IMPERSONATE ON USER:: WebReadUS TO automation
	GRANT IMPERSONATE ON USER:: WebReadMX TO automation
	GRANT IMPERSONATE ON USER:: WebReadUK TO automation
	GRANT IMPERSONATE ON USER:: WebReadUSMX TO automation
	GRANT IMPERSONATE ON USER:: WebReadFRCA TO automation
END
else if (@dbName = 'WebDB_ASIA')
BEGIN
	GRANT IMPERSONATE ON USER:: WebReadRegion TO automation
	GRANT IMPERSONATE ON USER:: WebUserJP TO automation
	GRANT IMPERSONATE ON USER:: WebUserENJP TO automation
	GRANT IMPERSONATE ON USER:: WebReadRegion TO automation
	GRANT IMPERSONATE ON USER:: WebReadJP TO automation
	GRANT IMPERSONATE ON USER:: WebReadENJP TO automation
END
else if (@dbName = 'WebDB_EU')
BEGIN
	GRANT IMPERSONATE ON USER:: WebUserDE TO automation
	GRANT IMPERSONATE ON USER:: WebUserENDE TO automation
	GRANT IMPERSONATE ON USER:: WebUserES TO automation
	GRANT IMPERSONATE ON USER:: WebUserFR TO automation
	GRANT IMPERSONATE ON USER:: WebReadDE TO automation
	GRANT IMPERSONATE ON USER:: WebReadENDE TO automation
	GRANT IMPERSONATE ON USER:: WebReadES TO automation
	GRANT IMPERSONATE ON USER:: WebReadFR TO automation
END

