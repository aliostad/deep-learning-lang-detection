CREATE PROCEDURE [dbo].[sp_UpdateClient]
	@Customer_id int,
	@Customer_type char(1),
	@Customer_EGN_BULSTAT nvarchar(13),
	@Customer_fullname nvarchar(400),
	@Customer_EMAIL nvarchar(400),
	@Customer_Phone nvarchar(400),
	@Customer_address nvarchar(400),
	@Customer_clientNote nvarchar(400)
AS
	BEGIN
	UPDATE CLIENT
	 set
	 CLIENT_TYPE=@Customer_type,CLIENT_EGN_BULSTAT=@Customer_EGN_BULSTAT,CLIENT_FULLNAME=@Customer_fullname,EMAIL=@Customer_EMAIL,TELEPHONE=@Customer_Phone ,ADRESS_TEXT=@Customer_address,CLIENT_NOTE=@Customer_clientNote
	 where CLIENT_ID=@Customer_id
	END
