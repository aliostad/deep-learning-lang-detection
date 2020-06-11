SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[WriteJobFile]
    @TaskId int,
    @Computer nvarchar(256),
    @JobFile image,
    @Append bit
AS

DECLARE @JobFilePtr binary(16)

IF @Append = 1
BEGIN
    SELECT
        @JobFilePtr = TEXTPTR(Job)
    FROM
        DistributedTasks
    WHERE
        TaskId = @TaskId
        AND
        ComputerId = ( SELECT ComputerId FROM Computers WHERE Name = @Computer )
END

IF @Append = 0 OR @JobFilePtr IS NULL
BEGIN
    UPDATE
        DistributedTasks
    SET
        Job = @JobFile
    WHERE
        TaskId = @TaskId
        AND
        ComputerId = ( SELECT ComputerId FROM Computers WHERE Name = @Computer )
END
ELSE
BEGIN
    UPDATETEXT DistributedTasks.Job @JobFilePtr NULL 0 @JobFile
END


GO
GRANT EXECUTE ON  [dbo].[WriteJobFile] TO [Resource Migrators]
GO
