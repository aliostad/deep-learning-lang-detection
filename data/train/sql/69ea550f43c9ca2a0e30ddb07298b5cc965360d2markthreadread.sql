CREATE PROCEDURE markthreadread @userid int, @threadid int, @postindex int, @force int = 0
AS
BEGIN TRANSACTION

	DECLARE @ErrorCode int, @CountPosts int, @LastPostsRead int,  @Private int
	
	-- Get the current unread post count
	SELECT @CountPosts = CountPosts, @LastPostsRead =  LastPostCountRead, @Private = Private FROM ThreadPostings WITH(UPDLOCK) WHERE UserID = @UserID AND ThreadID = @ThreadID 	

	IF (@force = 0)
	BEGIN
		UPDATE dbo.ThreadPostings SET LastPostCountRead = @postindex
			WHERE UserID = @userid AND ThreadID = @threadid AND (LastPostCountRead IS NULL OR LastPostCountRead < @postindex)
	END
	ELSE
	BEGIN
		UPDATE dbo.ThreadPostings SET LastPostCountRead = @postindex
			WHERE UserID = @userid AND ThreadID = @threadid
	END
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- Update the users UnreadPrivateMessageCount if the thread belongs to their private message centre
	IF ( @Private = 1 )
	BEGIN
		-- PostCount is updated as a queued/independent process.  
		-- Only mark private message read if the processthreadpostings job has updated countposts and unreadprivatemessagecount
		declare @postsread int, @readcount int
		SET @postsread = CASE WHEN @postindex > @CountPosts THEN @CountPosts ELSE @postindex END
		SET @readcount = CASE WHEN @postsread > @LastPostsRead THEN @postsread - @LastPostsRead ELSE 0 END	
		
		UPDATE dbo.Users
			SET UnreadPrivateMessageCount = CASE WHEN (UnreadPrivateMessageCount - @readcount) > 0 THEN (UnreadPrivateMessageCount - @readcount) ELSE 0 END
		WHERE UserID = @UserID
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END

COMMIT TRANSACTION