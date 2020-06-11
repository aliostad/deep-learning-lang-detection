USE [SnackOverflowDB]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE type = 'P' AND  name = 'sp_update_deal')
BEGIN
DROP PROCEDURE sp_update_deal
Print '' print  ' *** dropping procedure sp_update_deal'
End
GO

Print '' print  ' *** creating procedure sp_update_deal'
GO
Create PROCEDURE sp_update_deal
(
@old_DEAL_ID[INT],
@old_DESCRIPTION[NVARCHAR](200),
@new_DESCRIPTION[NVARCHAR](200),
@old_CODE[NCHAR](10)=null,
@new_CODE[NCHAR](10),
@old_AMOUNT[DECIMAL](5,2)=null,
@new_AMOUNT[DECIMAL](5,2),
@old_PERCENT_OFF[DECIMAL](5,2)=null,
@new_PERCENT_OFF[DECIMAL](5,2)
)
AS
BEGIN
UPDATE deal
SET DESCRIPTION = @new_DESCRIPTION, CODE = @new_CODE, AMOUNT = @new_AMOUNT, PERCENT_OFF = @new_PERCENT_OFF
WHERE (DEAL_ID = @old_DEAL_ID)
AND (DESCRIPTION = @old_DESCRIPTION)
AND (CODE = @old_CODE OR ISNULL(CODE, @old_CODE) IS NULL)
AND (AMOUNT = @old_AMOUNT OR ISNULL(AMOUNT, @old_AMOUNT) IS NULL)
AND (PERCENT_OFF = @old_PERCENT_OFF OR ISNULL(PERCENT_OFF, @old_PERCENT_OFF) IS NULL)
END
