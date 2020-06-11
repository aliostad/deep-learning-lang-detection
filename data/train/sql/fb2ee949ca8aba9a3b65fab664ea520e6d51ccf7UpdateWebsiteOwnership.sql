-- =============================================
-- Author:		Mark Entingh
-- Create date: 12/18/2013
-- Description:	transfer ownership of a website
-- =============================================
CREATE PROCEDURE UpdateWebsiteOwnership 
	@websiteId int = 0, 
	@newOwnerId int = 0
AS
BEGIN
	UPDATE ApplicationsOwned SET ownerid=@newOwnerId WHERE websiteid=@websiteId 
	UPDATE Pages SET ownerid=@newOwnerId WHERE websiteid=@websiteId 
	UPDATE WebSites SET ownerid=@newOwnerId WHERE websiteid=@websiteId 
	DELETE FROM WebsiteSecurity WHERE userId=@newOwnerId AND websiteid=@websiteId 
END
