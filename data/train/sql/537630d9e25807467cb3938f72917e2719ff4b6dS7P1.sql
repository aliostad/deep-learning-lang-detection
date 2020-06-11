SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fengfu Chen
-- Create date: 18/03/2014
-- Description:	Solution for Section 7 - Changing data
-- =============================================
CREATE PROCEDURE usp_S7P1 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT	*
	INTO	NewHorse
	FROM	Horse

	SELECT	*
	INTO	NewEntry
	FROM	Entry

	SELECT	*
	INTO	NewEvent
	FROM	Event

	SELECT	*
	INTO	NewShow
	FROM	Show

	SELECT	*
	INTO	NewJudge
	FROM	Judge

	SELECT	*
	INTO	NewPrize
	FROM	Prize

END
GO
