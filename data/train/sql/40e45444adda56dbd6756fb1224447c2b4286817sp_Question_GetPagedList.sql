
CREATE PROCEDURE [dbo].[sp_Question_GetPagedList]
	@surveyNumber int = null
	,@startRowIndex int = 0
	,@maximumRows int = 20
	,@recordCount int OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;
	--若參數型別對應到.net的實值型別，並且參數允許null，請務必檢查is null並給預設值
	--if (@int is null) set @int = -1; 

	declare @sql nvarchar(max);
	set @sql = dbo.fn_GeneratePagedSql(
	'[Question]' --table
	, '[Number], [SurveyNumber], [Section], [Title], [Description], [Sequence],[Guid],[OptionDisplayType],[OptionIsVerticalList],[OptionDisplayPerRow],[OptionMultipleSelection],[OptionLimitMin],[OptionLimitMax],[OptionDisplayLines],[OptionIsRequired],[OptionLabelLeft],[OptionLabelRight],[OptionLevelStart],[OptionLevelEnd],[OptionShowOther],[OptionAppendToChoice], [OptionOtherLabel]' --reutrn columns
	, '[Number]' --sortExpressions
	, 'where [SurveyNumber] = isNull(@surveyNumber,[SurveyNumber])
	' --where conditions
	)
	EXECUTE sp_executesql @sql, N'@surveyNumber int, @startRowIndex int,@maximumRows int , @recordCount int output'
		,@surveyNumber=@surveyNumber, @startRowIndex=@startRowIndex, @maximumRows=@maximumRows, @recordCount=@recordCount out
END

