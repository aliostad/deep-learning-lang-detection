-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SurveyTarget_AppendGroupMember]
	-- Add the parameters for the stored procedure here
	@surveyNumber int
	,@groupId varchar(20)
	,@memberId varchar(20)
	,@name nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	delete from TargetDepartmentGroup where SurveyNumber = @surveyNumber;

	SET NOCOUNT OFF;
    -- Insert statements for procedure here
	insert Into TargetGroupMember (SurveyNumber,GroupId,MemberId,[Name]) 
	values (@surveyNumber,@groupId,@memberId, @name)

END
