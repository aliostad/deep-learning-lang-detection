
CREATE PROCEDURE [OT_ADMIN_AssignReportToUserSet]
@reportSetId int,
@userSetId int,
@companyId int
As
If not exists (SELECT 1 from OUTTASK_USER_SET_READ_ACCESS with (nolock) where SET_ID = @reportSetId and READ_SET_ID = @userSetId)
BEGIN
	Insert Into OUTTASK_USER_SET_READ_ACCESS (SET_ID, READ_SET_ID)
	Select @reportSetId, @userSetId
	From OUTTASK_USER_SET us with (nolock)
	Join OUTTASK_USER u with (nolock) on u.COMPANY_ID = us.COMPANY_ID
	Where us.SET_ID = @reportSetId
	  And us.SET_TYPE = 'R'
	  And u.SET_ID = @userSetId
	  and u.COMPANY_ID = @companyId
END

