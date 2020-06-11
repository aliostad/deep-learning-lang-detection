CREATE PROCEDURE [MAIL_BOX_READ]
	@strRecipientID	varchar(21),
	@nLetterID		int
AS
BEGIN
	SELECT strMessage FROM MAIL_BOX 
	WHERE strRecipientID = @strRecipientID
	AND id = @nLetterID
	
	-- Mark the letter as read
	IF (@@ROWCOUNT != 0)
	BEGIN
		-- If there's no item attached, it can go straight to saved
		UPDATE MAIL_BOX SET dtReadDate = GETDATE(), bStatus = 2 
		WHERE id = @nLetterID AND bType = 1 AND dtReadDate IS NULL

		-- Otherwise, just update the time and mark it as read.
		UPDATE MAIL_BOX SET dtReadDate = GETDATE() 
		WHERE id = @nLetterID AND bType = 2 AND dtReadDate IS NULL
	END
END