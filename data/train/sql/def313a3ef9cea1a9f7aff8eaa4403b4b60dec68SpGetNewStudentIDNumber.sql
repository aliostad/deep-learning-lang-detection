SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Shirantha Fernando>
-- Create date: <2012/11/25>
-- Description:	<This SP used to get the current 'StudentID' number when 'New Registration' Buton click on Main Form>
-- =============================================
CREATE PROCEDURE [dbo].[SpGetNewStudentIDNumber] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;	

    DECLARE @NewStudentID INT	
		
	--Get the new StudentID Number
	SELECT @NewStudentID = (SELECT s.StudentId FROM dbo.StudentIdNumberHolder s)
	
	RETURN @NewStudentID
END
GO
