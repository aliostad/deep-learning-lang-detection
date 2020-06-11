-- =============================================
-- Author:		Ranjeet Kumar
-- Create date: 02-May-14
-- Description:	Edit the customer details and audit the changes.
-- =========================================================
CREATE PROCEDURE [dbo].[TC_UpdateCustomerDetails] 
@TC_CustomerId INT,
@NewName VARCHAR(100),
@NewLastName VARCHAR(100),
@NewMobile VARCHAR(15),
@NewEmail VARCHAR(100),
@NewAddress VARCHAR(200),
@Salutation VARCHAR(20),		
@UserId INT
--@DateModified DATE
AS
BEGIN
	SET NOCOUNT OFF;

DECLARE @OldTC_CustomerName NVARCHAR(100),@OldLastName NVARCHAR(100),@OldMobile NVARCHAR(15), @OldAddress NVARCHAR(200),@OldEmail NVARCHAR(100)
DECLARE @BranchId INT
--Get the old values
SELECT 
		@OldTC_CustomerName= TC.CustomerName, 
		@OldLastName = TC.LastName,
		@OldMobile = TC.Mobile, 
		@OldEmail = TC.Email,
		@OldAddress = TC.Address,
		@BranchId = TC.BranchId
		FROM TC_CustomerDetails AS TC 
						WHERE TC.id = @TC_CustomerId



--Update customer
--Check if Mobile Number not exist for same Branch 
IF (SELECT COUNT(Id) FROM TC_CustomerDetails WHERE Mobile = @NewMobile AND BranchId = @BranchId AND Id <> @TC_CustomerId) = 0
BEGIN
UPDATE  [dbo].[TC_CustomerDetails]
        SET [CustomerName] = @NewName
           ,[Email] = @NewEmail
           ,[Mobile] = @NewMobile
		   ,[LastName] = @NewLastName
		   ,[Address] = @NewAddress
		   ,[ModifiedDate] = GETDATE()
		   ,[ModifiedBy] = @UserId,
		   [Salutation] = @Salutation
		   WHERE id = @TC_CustomerId --Condition
	--Audit the customer details
	INSERT INTO [dbo].[AuditCustomerDetails]
           ([TC_CustomerId]
           ,[OldTC_CustomerName]
           ,[NewTC_CustomerName]
           ,[OldLastName]
           ,[NewLastName]
           ,[OldMobile]
           ,[NewMobile]
           ,[OldEmail]
           ,[NewEmail]
           ,[OldAddress]
           ,[NewAddress]
           ,[UserId]
           ,[DateModified])
     VALUES
			(@TC_CustomerId,
			@OldTC_CustomerName,
			@NewName,
			@OldLastName,
			@NewLastName,
			@OldMobile,
			@NewMobile,
			@OldEmail,
			@NewEmail,
			@OldAddress,
			@NewAddress,
			@UserId,
			GETDATE())

--Return status

SELECT 1 AS Status
END 
ELSE
SELECT 0  AS Status
END
