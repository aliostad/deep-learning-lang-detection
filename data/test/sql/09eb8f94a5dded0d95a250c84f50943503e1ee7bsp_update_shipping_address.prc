USE [SnackOverflowDB]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE type = 'P' AND  name = 'sp_update_shipping_address')
BEGIN
DROP PROCEDURE sp_update_shipping_address
Print '' print  ' *** dropping procedure sp_update_shipping_address'
End
GO

Print '' print  ' *** creating procedure sp_update_shipping_address'
GO
Create PROCEDURE sp_update_shipping_address
(
@old_ADDRESS_ID[INT],
@old_USER_ID[INT],
@new_USER_ID[INT],
@old_ADDRESS1[NVARCHAR](100),
@new_ADDRESS1[NVARCHAR](100),
@old_ADDRESS2[NVARCHAR](100)=null,
@new_ADDRESS2[NVARCHAR](100),
@old_CITY[NVARCHAR](50),
@new_CITY[NVARCHAR](50),
@old_STATE[NCHAR](2),
@new_STATE[NCHAR](2),
@old_ZIP[NVARCHAR](10),
@new_ZIP[NVARCHAR](10),
@old_ADDRESS_NAME[NVARCHAR](50),
@new_ADDRESS_NAME[NVARCHAR](50)
)
AS
BEGIN
UPDATE shipping_address
SET USER_ID = @new_USER_ID, ADDRESS1 = @new_ADDRESS1, ADDRESS2 = @new_ADDRESS2, CITY = @new_CITY, STATE = @new_STATE, ZIP = @new_ZIP, ADDRESS_NAME = @new_ADDRESS_NAME
WHERE (ADDRESS_ID = @old_ADDRESS_ID)
AND (USER_ID = @old_USER_ID)
AND (ADDRESS1 = @old_ADDRESS1)
AND (ADDRESS2 = @old_ADDRESS2 OR ISNULL(ADDRESS2, @old_ADDRESS2) IS NULL)
AND (CITY = @old_CITY)
AND (STATE = @old_STATE)
AND (ZIP = @old_ZIP)
AND (ADDRESS_NAME = @old_ADDRESS_NAME)
END
