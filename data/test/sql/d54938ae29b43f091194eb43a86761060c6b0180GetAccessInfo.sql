CREATE PROCEDURE [dbo].[GetAccessInfo]
	@cuid varchar(10),
	@ip varchar(20),
	@pw varchar(20)
AS

Declare @settings varchar(5000)
Declare @UsrCount int
Declare @IsOK bit
Declare @isReadOnly bit

Set @Settings = '';
Set @UsrCount = 0;
Set @isOk = 0;
Set @IsReadOnly = 0;

-- Get User Settings
Select @Settings = Settings, @IsReadOnly = IsReadOnly, @UsrCount = (Len(CUID) )  from dbo._UserSettings 
Where CUID = @CUID and [pw] = @PW;

if (@UsrCount > 0)
  Set @IsOK = 1;

If (Len(@CUID) > 0)   -- Log User Access
	Update dbo._AccessLog
	Set LastAccessOn = GetutcDate(),  LastAccessFrom  =  @IP,  AccessOK = @IsOK
	Where UserID = @CUID

--- Retrieve user information
if (@IsOK =  1)
   Select *, @settings as Settings, @isReadOnly as IsReadOnly, @CUID as CUID From dbo.vAllUsers Where CUID = @CUID;