
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fr_LastReadPost_LastReadPost]'))
	DROP PROCEDURE [dbo].[fr_LastReadPost_LastReadPost]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fr_LastReadPost_Update]'))
	DROP PROCEDURE [dbo].[fr_LastReadPost_Update]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE fr_LastReadPost_Update
	@ApplicationId uniqueidentifier,
	@ContentId uniqueidentifier,
	@UserId int,
	@LastReadContentId uniqueidentifier,
	@LastReadReplyCount int,
	@LastReadDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @lastReadDateTbl datetime
	SELECT @lastReadDateTbl= LastReadDate FROM dbo.[fr_Forum_LastRead] WHERE ApplicationId = @ApplicationId AND ContentId = @ContentId AND UserId = @UserId

	IF @lastReadDateTbl IS NOT NULL AND @LastReadDate > @lastReadDateTbl
	BEGIN
		UPDATE dbo.[fr_Forum_LastRead] SET LastReadContentId = @LastReadContentId  , LastReadReplyCount = @LastReadReplyCount , LastReadDate = @LastReadDate  WHERE ApplicationId = @ApplicationId AND ContentId = @ContentId AND UserId = @UserId 
	END
	ELSE IF @lastReadDateTbl IS NULL 
	BEGIN
		INSERT INTO dbo.[fr_Forum_LastRead] (	[ApplicationId],[ContentId],[UserId],[LastReadContentId],[LastReadReplyCount] , [LastReadDate]) 
			VALUES (@ApplicationId , @ContentId , @UserId , @LastReadContentId , @LastReadReplyCount , @LastReadDate)
	END


END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE fr_LastReadPost_LastReadPost
	@ApplicationId uniqueidentifier,
	@ContentId uniqueidentifier,
	@UserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT LastReadContentId , [LastReadReplyCount] , [LastReadDate] FROM dbo.[fr_Forum_LastRead] WHERE ApplicationId = @ApplicationId AND ContentId = @ContentId AND UserId = @UserId

END
GO



