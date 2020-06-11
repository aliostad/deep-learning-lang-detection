CREATE PROCEDURE [dbo].[sp_isertCustomer1]
	@Customer_id int,
	@Customer_type char(1),
	@Customer_EGN_BULSTAT nvarchar(13),
	@Customer_fullname nvarchar(400),
	@Customer_EMAIL nvarchar(400),
	@Customer_Phone nvarchar(400),
	@Customer_address nvarchar(400),
	@Customer_clientNote nvarchar(400)
	
AS
	insert into CLIENT(CLIENT_ID,CLIENT_TYPE,CLIENT_EGN_BULSTAT,CLIENT_FULLNAME,EMAIL,TELEPHONE,ADRESS_TEXT,CLIENT_NOTE)
	values(@Customer_id,@Customer_type,@Customer_EGN_BULSTAT,@Customer_fullname,@Customer_EMAIL,@Customer_Phone,@Customer_address,@Customer_clientNote);
RETURN 