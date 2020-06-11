

CREATE PROCEDURE [dbo].[GetContactInfo] 
	@cuid varchar(10) = '', 
	@initials varchar(10) = '',
	@State varchar(10) = '',
	@grp varchar (10) = '',
	@attid varchar(20) = ''
AS

if (Len(@CUID) > 0) Begin
	Declare @settings varchar(5000)	
	Declare @isReadOnly bit
	
	Set @Settings = '';	
	Set @IsReadOnly = 0;
	
	-- Get User Settings
	Select @Settings = Settings, @IsReadOnly = IsReadOnly from dbo._UserSettings 
	Where UserID = @CUID or UserID = @attid;
	
	Select *, @settings as Settings, @isReadOnly as IsReadOnly, @CUID as CUID From dbo.vAllUsers Where CUID = @CUID or attid = @attid;

End 
Else
	Select * from vAllUsers Where State = @State and Initials = @Initials and Grp = @Grp;

