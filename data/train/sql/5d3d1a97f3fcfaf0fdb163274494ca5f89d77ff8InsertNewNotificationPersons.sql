-- =============================================
-- Author:		@Author,,Name>
-- Create date: @Create Date, 
-- Description:	@Description, 
-- =============================================
CREATE PROCEDURE [dbo].[InsertNewNotificationPersons]
            @NotificationPersonID int out
	       ,@NotificationID int 
           ,@PersonID int 
           ,@IsRead bit 
           ,@UserName nvarchar(50) 
           ,@ModifiedDate datetime 
AS
BEGIN
  INSERT INTO [dbo].[NotificationPersons]
           ([NotificationID]
           ,[PersonID]
           ,[IsRead]
           ,[UserName]
           ,[ModifiedDate])
     VALUES
           (@NotificationID
           ,@PersonID
           ,@IsRead
           ,@UserName           
           ,@ModifiedDate
           )
   set @NotificationPersonID = @@IDENTITY
   
END
