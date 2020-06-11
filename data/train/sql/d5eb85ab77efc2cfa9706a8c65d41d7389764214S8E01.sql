
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fengfu Chen
-- Create date: 19/03/2014
-- Description:	SQL Section 8 - Examples
-- =============================================
CREATE PROCEDURE usp_S8E01 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- This query use a simple 'Product' join.
	SELECT *
	FROM	Model,
			Appliance
	WHERE	model.model_code = Appliance.model_num

	-- Here's the same query  using an 'Inner Join'
	SELECT *
	FROM		Model
	INNER JOIN	Appliance
	ON			model.model_code = Appliance.model_num


END
GO
