USE [MicroWiki]
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'mw_Read_Documents')
    DROP PROCEDURE [dbo].[mw_Read_Documents]
GO

CREATE PROCEDURE [dbo].[mw_Read_Documents] 
(
    @ParentID nvarchar(64) = NULL
)
AS
BEGIN 
	SET NOCOUNT ON
	
	IF @ParentID IS NOT NULL
	BEGIN
	    SELECT 
            ID,
            ParentID,
            Title,
            Location
        FROM 
            Documents 
        WHERE 
            ID != @ParentID
        AND
            ParentID = @ParentID
        ORDER BY 
            Title
    END
    ELSE
    BEGIN
        SELECT 
            ID,
            ParentID,
            Title,
            Location
        FROM 
            Documents
        ORDER BY 
            Title
    END
END	
GO

