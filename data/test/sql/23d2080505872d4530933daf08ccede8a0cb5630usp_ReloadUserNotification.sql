USE [EnterpriseDbTest]

-- Disable all constraints so we can load data
ALTER TABLE [dbo].[UserNotification] NOCHECK CONSTRAINT all

-- Delete all data from tables
DELETE FROM [dbo].[UserNotification]

-- Reseed the identity column starting values
DBCC CHECKIDENT('[dbo].[UserNotification]', RESEED, 0)

-- Insert the test data
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(1, DATEADD(day, -2,  GETDATE()), DATEADD(day, -1, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(1, DATEADD(day, -1,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(2, DATEADD(day, -3,  GETDATE()), DATEADD(day, -2, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(2, DATEADD(day, -2,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(3, DATEADD(day, -4,  GETDATE()), DATEADD(day, -3, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(3, DATEADD(day, -3,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(4, DATEADD(day, -5,  GETDATE()), DATEADD(day, -4, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(4, DATEADD(day, -4,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(5, DATEADD(day, -6,  GETDATE()), DATEADD(day, -5, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(5, DATEADD(day, -5,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(6, DATEADD(day, -7,  GETDATE()), DATEADD(day, -6, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(6, DATEADD(day, -6,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(7, DATEADD(day, -8,  GETDATE()), DATEADD(day, -7, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(7, DATEADD(day, -7,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(8, DATEADD(day, -9,  GETDATE()), DATEADD(day, -8, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(8, DATEADD(day, -8,  GETDATE()), NULL)
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(9, DATEADD(day, -10, GETDATE()), DATEADD(day, -9, GETDATE()))
INSERT INTO [dbo].[UserNotification]([UserID] ,[DatePosted] ,[DateRead])VALUES(9, DATEADD(day, -9,  GETDATE()), NULL)

-- Enable all constraints
ALTER TABLE [dbo].[UserNotification] WITH CHECK CHECK CONSTRAINT all
