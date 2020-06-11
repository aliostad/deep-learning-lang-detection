-- =============================================  
-- Author:  Kritika Choudhary
-- Create date: 8th June 2015
-- Description: To Activate And DeActivate Dealer Model Banners  
-- =============================================  
CREATE PROCEDURE [dbo].[Microsite_UpdateModelBanners]   
(  
 @Id INT
)  
AS  
DECLARE @Activation BIT 
BEGIN   
	
	SET @Activation = (SELECT IsActive FROM Microsite_DealerModelBanners WHERE ID = @Id)
	
	IF(@Activation = 0)
		BEGIN  
			UPDATE Microsite_DealerModelBanners SET IsActive=1
			WHERE ID=@Id 
		END 
	ELSE
		BEGIN
			UPDATE Microsite_DealerModelBanners SET IsActive=0
			WHERE ID=@Id 
		END 
END  
