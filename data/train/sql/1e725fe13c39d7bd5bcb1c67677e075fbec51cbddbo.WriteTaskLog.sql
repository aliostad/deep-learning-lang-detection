SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WriteTaskLog]
    @TaskId int,
    @LogFile image,
    @Append bit
AS

DECLARE @LogFilePtr binary(16)

IF @Append = 1
BEGIN
    SELECT
        @LogFilePtr = TEXTPTR(LogFile)
    FROM
        LocalTasks
    WHERE
        TaskId = @TaskId
END

IF @Append = 0 OR @LogFilePtr IS NULL
BEGIN
    UPDATE
        LocalTasks
    SET
        LogFile = @LogFile
    WHERE
        TaskId = @TaskId
END
ELSE
BEGIN
    UPDATETEXT LocalTasks.LogFile @LogFilePtr NULL 0 @LogFile
END


GO
GRANT EXECUTE ON  [dbo].[WriteTaskLog] TO [Resource Migrators]
GO
