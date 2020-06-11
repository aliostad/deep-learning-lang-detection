
Create PROCEDURE [dbo].[sp_TargetForGroup_AppendMember]
	@surveyNumber int = null
	,@groupId varchar(20) = null
	,@memberId varchar(20) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	begin tran T1
	Delete FROM [dbo].[TargetForGroup] where [SurveyNumber] = @surveyNumber and MemberId is null;


	if (not exists(select 0 from [dbo].[TargetForGroup] where [SurveyNumber] = @surveyNumber and MemberId = @memberId))
	insert into [dbo].[TargetForGroup] (SurveyNumber, GroupId, MemberId, TargetMark)
		values (@surveyNumber, @groupId, @memberId, 2);

	update Survey set TargetMark = 2 where Number = @surveyNumber;

	commit tran T1

END

