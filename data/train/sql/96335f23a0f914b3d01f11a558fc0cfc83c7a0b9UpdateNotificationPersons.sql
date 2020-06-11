-- =============================================
-- Author:		@Author,,Name>
-- Create date: @Create Date, 
-- Description:	@Description, 
-- =============================================
CREATE PROCEDURE [dbo].[UpdateNotificationPersons]
            @OldNotificationPersonID int
	       ,@NotificationID int 
           ,@PersonID int 
           ,@IsRead bit 
           ,@UserName nvarchar(50) 
           ,@ModifiedDate datetime 
AS
BEGIN
  UPDATE [dbo].[NotificationPersons]
   SET [NotificationID] =  @NotificationID 
      ,[PersonID] =  @PersonID 
      ,[IsRead] =  @IsRead
      ,[UserName] =  @UserName 
      ,[ModifiedDate] =  ModifiedDate
   WHERE NotificationPersonID = @OldNotificationPersonID
   
END
