CREATE PROCEDURE [dbo].[SP_UpdateVisitorRecord]
@Blog_ID INT,
@Reader_IP NVARCHAR(15),
@Country NVARCHAR (100)=NULL,
@Region NVARCHAR (100)=NULL,
@City NVARCHAR (100)=NULL,
@ZipCode NVARCHAR (10)=NULL,
@Latitude REAL=NULL,
@Longitude REAL=NULL,
@RecordTime DATETIME=NULL,
@ReadTimes INT = NULL OUTPUT
AS 
BEGIN
SET @ReadTimes = (SELECT Read_Times FROM Blog WHERE Blog_ID=@Blog_ID)
-- Record new visiter IP Address
IF @RecordTime IS NULL
	SET @RecordTime=GETDATE()
INSERT INTO VisitorRecord VALUES(@Blog_ID,@Reader_IP,@Country,@Region,@City,@ZipCode,@Latitude,@Longitude,@RecordTime)
SET @ReadTimes = @ReadTimes + 1
		
-- Update Read_Times field in Blog table
UPDATE Blog SET Read_Times=@ReadTimes WHERE Blog_ID=@Blog_ID
END
