CREATE TABLE dbo.Users (
	[Id] int NOT NULL identity(0,1) primary key,
	[UserName] varchar(50) NOT NULL,
	[Password] varbinary(255) NOT NULL,
	[Salt] char(25) NOT NULL,
	[SessionID] varchar(120) NULL,
	[Color] varchar(50) NOT NULL
);
GO

CREATE UNIQUE INDEX NDX_SecurityAccounts_AccountName 
    ON dbo.Users (UserName) INCLUDE (Salt, Password);
GO 

CREATE PROC dbo.CreateAccount
  @NewAccountName VARCHAR(50),
  @NewAccountPwd VARCHAR(100),
  @NewAccountColor VARCHAR(50)
AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @Salt VARCHAR(25);
  DECLARE @PwdWithSalt VARCHAR(125);
  
  DECLARE @Seed int;
  DECLARE @LCV tinyint;
  DECLARE @CTime DATETIME;

  SET @CTime = GETDATE();
  SET @Seed = (DATEPART(hh, @Ctime) * 10000000) + (DATEPART(n, @CTime) * 100000)
      + (DATEPART(s, @CTime) * 1000) + DATEPART(ms, @CTime);
  SET @LCV = 1;
  SET @Salt = CHAR(ROUND((RAND(@Seed) * 94.0) + 32, 3));

  WHILE (@LCV < 25)
  BEGIN
    SET @Salt = @Salt + CHAR(ROUND((RAND() * 94.0) + 32, 3));
	SET @LCV = @LCV + 1;
  END;


  SET @PwdWithSalt = @Salt + @NewAccountPwd;

  INSERT INTO dbo.Users 
  (UserName, Salt, Password, Color)
  VALUES (@NewAccountName, @Salt, HASHBYTES('SHA1', @PwdWithSalt), @NewAccountColor);
END;
GO 

CREATE PROC dbo.VerifyAccount
  @AccountName VARCHAR(50),
  @AccountPwd VARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @Salt CHAR(25);
  DECLARE @PwdWithSalt VARCHAR(125);
  DECLARE @PwdHash VARBINARY(20);  

  SELECT @Salt = Salt, @PwdHash = Password 
  FROM dbo.Users WHERE UserName = @AccountName;
  
  SET @PwdWithSalt = @Salt + @AccountPwd;

  SELECT 1
  WHERE (HASHBYTES('SHA1',@PwdWithSalt) = @PwdHash)

END;
GO 

exec dbo.CreateAccount @NewAccountName = 'test', @NewAccountPwd='123', @NewAccountColor='blue'
exec dbo.CreateAccount @NewAccountName = 'gabriel', @NewAccountPwd='gabriel123', @NewAccountColor='blue'
exec dbo.CreateAccount @NewAccountName = 'lisa', @NewAccountPwd='lisa123', @NewAccountColor='blue'
exec dbo.CreateAccount @NewAccountName = 'erik', @NewAccountPwd='erik123', @NewAccountColor='blue'