--==================--
-- DATA VERSION 1.0 --
--==================--

IF NOT EXISTS(SELECT * FROM Clients WHERE ClientID='{ClientID}')
BEGIN
	BEGIN TRANSACTION

	DECLARE @newClientID uniqueidentifier,
			@newUserID uniqueidentifier,
			@perm1ID uniqueidentifier,
			@perm2ID uniqueidentifier,
			@perm3ID uniqueidentifier

	SELECT @newClientID = '{ClientID}',
			@newUserID = NEWID(),
			@perm1ID = NEWID(),
			@perm2ID = NEWID(),
			@perm3ID = NEWID()

	EXEC dbo.CreateClient @newClientID, 'SprocketCMS', 1, @newUserID, NULL
	EXEC dbo.CreateUser @newUserID, @newClientID, 'admin', '{password-hash}', 'System', 'Administrator', 'admin@localhost', 1, 0, 1, 1, null
	EXEC dbo.CreatePermissionType @perm1ID, 'USERADMINISTRATOR', 'Access User Administration', 0, 'SecurityProvider'
	EXEC dbo.CreatePermissionType @perm2ID, 'ROLEADMINISTRATOR', 'Create and Modify Roles', 0, 'SecurityProvider'
	EXEC dbo.CreatePermissionType @perm3ID, 'SUPERUSER', 'Unrestricted Access', 0, 'SecurityProvider'
	EXEC dbo.AssignPermission 'SUPERUSER', NULL, @newUserID

	IF @@ERROR = 0
		COMMIT TRANSACTION
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR ('SQL Error initialising SecurityProvider module (sqlserver_data_001.sql)', 16, 1)
	END
END