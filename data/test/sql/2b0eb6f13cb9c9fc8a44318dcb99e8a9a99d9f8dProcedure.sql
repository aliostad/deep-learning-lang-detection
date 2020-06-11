USE m12nvv;

IF OBJECT_ID('dbo.CheckPosition', 'P') IS NOT NULL DROP PROCEDURE dbo.CheckPosition;
GO
--check if we can move figure from old to new 
--result equals to 0 if there is no figure or if there is a figure of the same color at the new coordinats
--... 1 if there is no figure at new and move figure from old to new
--... 2 if there is a figure of opposite color and move figure to new, replacing another
CREATE PROCEDURE dbo.CheckPosition(@x_old int, @y_old varchar(1), @x_new int, @y_new varchar(1), @result int OUTPUT)
AS
BEGIN
	IF (SELECT COUNT(*) FROM Chessboard WHERE Chessboard.x = @x_old AND Chessboard.y = @y_old) <> 1 SET @result = 0
	IF (SELECT COUNT(*) FROM Chessboard WHERE Chessboard.x = @x_new AND Chessboard.y = @y_new) = 0 
	BEGIN
		UPDATE Chessboard
		SET x = @x_new, y = @y_new 
		WHERE x = @x_old AND y = @y_old
	END
	ELSE
	BEGIN
		DECLARE @figureColor varchar(1)
		IF (SELECT Figures.color FROM Chessboard, Figures WHERE Chessboard.cid = Figures.cid AND x = @x_new AND y = @y_new) = 
		(SELECT Figures.color FROM Chessboard, Figures WHERE Chessboard.cid = Figures.cid AND x = @x_old AND y = @y_old)
		BEGIN
			SET @result = 0
		END
		ELSE
		BEGIN
			DELETE FROM Chessboard WHERE x = @x_new AND y = @y_new
			UPDATE Chessboard
			SET x = @x_new, y = @y_new 
			WHERE x = @x_old AND y = @y_old
			SET @result = 2
		END
	END
END

GO

