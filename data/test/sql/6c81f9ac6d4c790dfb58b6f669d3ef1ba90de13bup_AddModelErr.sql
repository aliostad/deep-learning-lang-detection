IF OBJECT_ID(N'up_AddModelErr') IS NOT NULL
	DROP PROC up_AddModelErr;
GO


CREATE PROC up_AddModelErr
	@Make	varchar(30)	= 'ACURA',
	@Model	varchar(30)	= 'RDX',
	@ModelErr	varchar(30)	= NULL
AS
-- SET NOCOUNT ON;

-- DECLARE @t TABLE
CREATE TABLE #t
(
	ModelErr	varchar(30)		NULL,
	Make		varchar(30)		NULL,
	Model		varchar(30)		NULL
);

IF (@ModelErr IS NULL)
BEGIN
	DECLARE @SQL varchar(8000) = NULL;

	SELECT @SQL = 'INSERT #t (ModelErr, Make, Model) ' + 
				  'SELECT DISTINCT Model, Make, ''' + @Model + ''' '  +
				  'FROM CarData.Car ' +
				  'WHERE Make = ''' + @Make + ''' ' +
				  '  AND Model like ''' + @Model + '%'' ' + 
				  '  AND Model <> ''' + @Model + '''' ;
	EXEC (@SQL);
END

ELSE
BEGIN
	INSERT #t
	SELECT @ModelErr, @Make, @Model;	
END

DELETE #t
FROM #t t, CarData.ModelErr e
where t.ModelErr = e.ModelErr
  and t.Make = e.Make
  and t.Model = e.Model
;

INSERT CarData.ModelErr (Model, Make, ModelErr)
SELECT Model, Make, ModelErr
FROM #t
;

UPDATE CarData.Car set Model = e.Model
FROM CarData.Car c, CarData.ModelErr e
WHERE c.Make = e.Make
  AND c.Model = e.ModelErr;

GO

exec up_AddModelErr;
