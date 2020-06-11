
CREATE PROCEDURE OT_MASTER_DatabaseConnectionUpdate (@DatabaseId int, @DatabaseName varchar(128), @applicationGroup varchar(24), @MaintenanceZone char(4), 
	@ServerName varchar(128), @UserName varchar(64), @Password varchar(256), @PortNum int, @IsActive bit, @FailoverPartner varchar(128), @FailoverPortNum int, 
	@dbKind tinyint = 0, @connectionName varchar(64) = null, @shardingWeight int = null, @ReadOnlyServerName varchar(128) = null, @ReadOnlyPortNum int = null,
	@BatchServerName varchar(128) = null, @BatchPortNum int = null, @MSReadOnly bit = 0, @MSHighAvail bit = 0, @maxPoolSize int = null)
AS
BEGIN
	UPDATE MASTER_DATABASE_CONNECTION
	SET DATABASE_NAME = @DatabaseName, 
		APPLICATION_GROUP = @applicationGroup, 
		MAINTENANCE_ZONE = @MaintenanceZone, 
		SERVER_NAME = @ServerName, 
		USER_NAME = @UserName, 
		PASSWORD = @Password, 
		PORT_NUM = @PortNum, 
		IS_ACTIVE = @IsActive,
		FAILOVER_PARTNER = @FailoverPartner,
		FAILOVER_PORT_NUM = @FailoverPortNum,
		DB_KIND = @dbKind,
		--DB_TENANCY doesn't get set via ui
		CONNECTION_NAME = case when @dbKind = 2 and @connectionName is not null then @connectionName else CONNECTION_NAME end, --we reset connection name for the progress single tenant connections to match the company domain.  other connections don't change name
		SHARDING_WEIGHT = @shardingWeight,
		LAST_MODIFIED_UTC = getUTCDate(),
		READ_REPLICA_SERVER_NAME = @ReadOnlyServerName,
		READ_REPLICA_PORT_NUM = @ReadOnlyPortNum,
		BATCH_SERVER_NAME = @BatchServerName,
		BATCH_PORT_NUM = @BatchPortNum,
		SQL_SERVER_READ_ONLY_CAPABLE = @MSReadOnly,
		SQL_SERVER_HIGH_AVAILABILITY_CAPABLE = @MSHighAvail,
		MAX_POOL_SIZE = @maxPoolSize
	WHERE DATABASE_ID = @DatabaseId
	return @@ROWCOUNT
END
