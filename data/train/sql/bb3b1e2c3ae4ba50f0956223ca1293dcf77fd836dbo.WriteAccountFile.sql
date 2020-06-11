SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WriteAccountFile]
    @TaskId int,
    @AccountFile image,
    @Append bit
AS

DECLARE @AccountFilePtr binary(16)

IF @Append = 1
BEGIN
    SELECT
        @AccountFilePtr = TEXTPTR(AccountFile)
    FROM
        LocalTasks
    WHERE
        TaskId = @TaskId
END

IF @Append = 0 OR @AccountFilePtr IS NULL
BEGIN
    UPDATE
        LocalTasks
    SET
        AccountFile = @AccountFile
    WHERE
        TaskId = @TaskId
END
ELSE
BEGIN
    UPDATETEXT LocalTasks.AccountFile @AccountFilePtr NULL 0 @AccountFile
END


GO
GRANT EXECUTE ON  [dbo].[WriteAccountFile] TO [Resource Migrators]
GO
