-- =============================================
-- Author:		Attila Pall
-- Create date: 12/09/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[h3giCreditCheckLogRead] 
	-- Add the parameters for the stored procedure here
	@orderRef int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT type, value, eventDate
	FROM h3giAutomatedCreditCheckLog
	WHERE orderRef = @orderRef
	ORDER BY eventDate DESC
END


GRANT EXECUTE ON h3giCreditCheckLogRead TO b4nuser
GO
GRANT EXECUTE ON h3giCreditCheckLogRead TO reportuser
GO
