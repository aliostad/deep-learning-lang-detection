-- =============================================
-- Author:		<Shalini Nair>
-- Create date: <30/09/14>
-- Description:	<Gets the ModelPage MetaTags based on ModelId passed>
-- =============================================
CREATE PROCEDURE [dbo].[PageMetaTagsByModel] 
	-- Add the parameters for the stored procedure here
	@PageId numeric ,
	@ModelId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  SELECT ModelId,Title,Description,Keywords,Heading,Summary,IsActive FROM PAGEMETATAGS WITH(NOLOCK) WHERE ISACTIVE=1  and PageId=@PageId and ModelId = @ModelId
END
