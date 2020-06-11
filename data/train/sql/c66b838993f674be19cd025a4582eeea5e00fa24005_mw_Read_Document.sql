USE [MicroWiki]
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'mw_Read_Document')
    DROP PROCEDURE [dbo].[mw_Read_Document]
GO

CREATE PROCEDURE [dbo].[mw_Read_Document] 
(
    @ID nvarchar(64) = NULL,
    @Location nvarchar(256) = NULL
)
AS
BEGIN 
	SET NOCOUNT ON
	
	IF @ID IS NOT NULL
	BEGIN
	    SELECT 
            ID,
            ParentID,
            Title,
            Body,
            Slug,
            Location,
            Created, 
            Updated,
            Username,
            TOC
        FROM 
            Documents 
        WHERE 
            ID = @ID
    END
    ELSE IF @Location IS NOT NULL
    BEGIN
	    SELECT 
            ID,
            ParentID,
            Title,
            Body,
            Slug,
            Location,
            Created, 
            Updated,
            Username,
            TOC
        FROM 
            Documents 
        WHERE 
            Location = @Location
    END
END	
GO

