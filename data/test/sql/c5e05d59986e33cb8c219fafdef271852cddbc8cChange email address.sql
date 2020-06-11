DECLARE @oldEmail VARCHAR(100)
DECLARE @newEmail VARCHAR(100)

SET @oldEmail = 'magz1111@hotmail.co.uk'
SET @newEmail = 'magz@centralfacilities.co.uk'

USE PeninsulaOnline
IF EXISTS (SELECT * FROM dbo.[User] AS u
WHERE UserName = @newEmail)
BEGIN
	PRINT 'new email is in use'
	RETURN 
END

SET XACT_ABORT ON

BEGIN TRANSACTION

UPDATE dbo.Membership
SET Email = @newEmail
	,LoweredEmail = LOWER(@newEmail)
FROM dbo.[User] AS u
	INNER JOIN dbo.Membership AS m ON u.Id = m.UserId
WHERE UserName = @oldEmail
AND m.Deleted = 0

UPDATE dbo.[User]
SET UserName = @newEmail
	,LoweredUserName = LOWER(@newEmail)
FROM dbo.[User] AS u
	INNER JOIN dbo.Membership AS m ON u.Id = m.UserId
WHERE UserName = @oldEmail
AND m.Deleted = 0

USE BusinessSafe

UPDATE dbo.EmployeeContactDetails
SET Email = @newEmail
WHERE Email = @oldEmail

COMMIT TRAN