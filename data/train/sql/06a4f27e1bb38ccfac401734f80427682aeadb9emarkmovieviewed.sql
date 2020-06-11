Create Procedure markmovieviewed @userid int, @movieid int
As
	IF EXISTS (SELECT * FROM FlashMovies WHERE MovieID = @movieid AND Active = 1)
	BEGIN
		IF NOT EXISTS (SELECT * FROM ViewedMovies WHERE UserID = @userid AND MovieID = @movieid)
		BEGIN
			INSERT INTO ViewedMovies (UserID, MovieID) VALUES (@userid, @movieid)
		END
		SELECT URL, Description, MovieID FROM FlashMovies WHERE MovieID = @movieid
	END
	ELSE
		SELECT 'URL' = 'Default_movie', 'Description' = 'Connection unlikely', 'MovieID' = 0
	return (0)