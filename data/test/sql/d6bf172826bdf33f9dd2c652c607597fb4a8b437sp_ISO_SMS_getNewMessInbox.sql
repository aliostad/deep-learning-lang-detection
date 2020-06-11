/***********************************************************
* Purpose : SELECT NEW MESSAGE INBOX
* Author : Nguyen Chi Tam
* Date: 6 -4 - 2011
* Description: GET NEW MESSAGE INBOX
*/
IF EXISTS ( SELECT * FROM SYSOBJECTS WHERE NAME = 'sp_ISO_SMS_getNewMessInbox') 
BEGIN
	DROP PROC sp_ISO_SMS_getNewMessInbox
END
GO
CREATE PROC sp_ISO_SMS_getNewMessInbox
	@newMess	int
AS
BEGIN
	SELECT TOP (@newMess) So_Dien_Thoai,Noi_Dung_Tin_Nhan FROM HopThuDen ORDER BY ID DESC
END

--exec sp_ISO_SMS_getNewMessInbox 2