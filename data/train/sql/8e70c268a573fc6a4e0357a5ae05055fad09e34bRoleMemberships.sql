ALTER ROLE [db_owner] ADD MEMBER [CREDIBILITY\DB_DEV_ReadWrite];


GO
ALTER ROLE [db_owner] ADD MEMBER [CREDIBILITY\DB_Cirrus_DBO];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CREDIBILITY\DB_DEV_ReadOnly];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CREDIBILITY\DB_DEV_ReadWrite];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CREDIBILITY\DB_Cirrus_ReadOnly];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CREDIBILITY\DB_Cirrus_ReadWrite];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [CREDIBILITY\DB_DEV_ReadWrite];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [CREDIBILITY\DB_Cirrus_ReadWrite];

