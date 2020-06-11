SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WriteDistributedTaskLog]
    @TaskId int,
    @Computer nvarchar(256),
    @LogFile image,
    @Append bit
AS

DECLARE @LogFilePtr binary(16)

IF @Append = 1
BEGIN
    SELECT
        @LogFilePtr = TEXTPTR(LogFile)
    FROM
        DistributedTasks
    WHERE
        TaskId = @TaskId
        AND
        ComputerId = ( SELECT ComputerId FROM Computers WHERE Name = @Computer )
END

IF @Append = 0 OR @LogFilePtr IS NULL
BEGIN
    UPDATE
        DistributedTasks
    SET
        LogFile = @LogFile
    WHERE
        TaskId = @TaskId
        AND
        ComputerId = ( SELECT ComputerId FROM Computers WHERE Name = @Computer )
END
ELSE
BEGIN
    UPDATETEXT DistributedTasks.LogFile @LogFilePtr NULL 0 @LogFile
END


GO
GRANT EXECUTE ON  [dbo].[WriteDistributedTaskLog] TO [Resource Migrators]
GO
