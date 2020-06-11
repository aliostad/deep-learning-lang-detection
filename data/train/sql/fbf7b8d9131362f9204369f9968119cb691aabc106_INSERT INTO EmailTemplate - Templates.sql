--------------------------------------------------------------------------------------------------------------------------------------------------------
			/* Task Category required for user interface ddl */
----------------------------------------------------------------------------------------------------------------------------------------------------------


SET IDENTITY_INSERT [EmailTemplate] ON;

INSERT INTO [EmailTemplate]
           ([Id]
           ,[Name]
           ,[Subject]
           ,[Body]
           ,[Deleted]
           ,[CreatedOn]
           ,[CreatedBy])
     SELECT 1
           ,'CompanySummeryChangeNotification'
           ,'BusinessSafe - Change in Company Details'
           ,'Joanne Teasdale from 1 request on <date> the following details to be changed to their Main Company Details. Please find below the details of what they would like it to be changed to: <br />Company Name: $Model.CompanyName$ <br /> CAN: $Model.CAN$ <br /> Main Address: $Model.AddressLine1$ <br /> $Model.AddressLine2$ <br /> $Model.AddressLine3$ <br /> $Model.AddressLine4$ <br /> Postcode: $Model.Postcode$ <br /> Telephone: $Model.Telephone$ <br /> Website: $Model.Website$ <br /> Main Contact: $Model.MainContact$ <br />'
           ,0
           ,GETDATE()
           ,'790D8CC9-04F8-4643-90EE-FAED4BA711EC'
     WHERE NOT EXISTS (SELECT * FROM dbo.EmailTemplate AS et WHERE id=1)

                
   GO    
   
   INSERT INTO [EmailTemplate]
           ([Id]
           ,[Name]
           ,[Subject]
           ,[Body]
           ,[Deleted]
           ,[CreatedOn]
           ,[CreatedBy])
     SELECT 2
           ,'SiteAddressChangeNotification'
           ,'BusinessSafe - Change in Site Address Details'
           ,'Joanne Teasdale from 1 request on <date> the following details to be changed on one of their Site Addresses. Please find below the details of what they would like it to be changed to: <br />Company Name: $Model.CompanyName$ <br /> CAN: $Model.CAN$ <br /> Site Address: $Model.AddressLine1$ <br /> $Model.AddressLine2$ <br /> $Model.AddressLine3$ <br /> $Model.AddressLine4$ <br /> Postcode: $Model.Postcode$ <br /> Telephone: $Model.Telephone$ <br /> Website: $Model.Website$ <br /> Main Contact: $Model.MainContact$ <br />'
           ,0
           ,GETDATE()
           ,'790D8CC9-04F8-4643-90EE-FAED4BA711EC'
     WHERE NOT EXISTS (SELECT * FROM dbo.EmailTemplate AS et WHERE id=2)

                
   GO                               
SET IDENTITY_INSERT [EmailTemplate] OFF;

--//@UNDO 
USE [BusinessSafe]
GO

DELETE FROM [EmailTemplate] WHERE Id = 1

