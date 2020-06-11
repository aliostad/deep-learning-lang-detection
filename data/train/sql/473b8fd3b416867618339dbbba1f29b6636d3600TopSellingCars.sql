                 
                
CREATE PROCEDURE [cw].[TopSellingCars]         
 @ModelId int,        
 @Status bit     
AS                  
BEGIN                  
 -- SET NOCOUNT ON added to prevent extra result sets from                  
 -- interfering with SELECT statements.       
    
 IF  Exists(SELECT ModelId FROM Con_TopSellingCars WHERE ModelId=@ModelId)    
  BEGIN    
	UPDATE Con_TopSellingCars SET Status=@Status WHERE ModelId=@ModelId;    
  END    
 else    
  BEGIN    
	Insert into Con_TopSellingCars values (@ModelId,GETDATE(),NULL,NULL,@Status,NULL)    
  END         
END 
