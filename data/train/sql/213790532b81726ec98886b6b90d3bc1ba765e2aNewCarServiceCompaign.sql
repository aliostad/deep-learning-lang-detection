           
          
CREATE PROCEDURE [cw].[NewCarServiceCompaign]   
 @ModelId int,  
 @Status bit,  
 @Flag bit       
AS            
BEGIN            
 -- SET NOCOUNT ON added to prevent extra result sets from            
 -- interfering with SELECT statements.    
 DECLARE @count int
 SET @count = (Select COUNT(*)  from  PQ_Newcarservicecompaign where ModelId= @ModelId)  
 SET NOCOUNT ON;
          IF @Flag=1 AND @count=0  
  Insert into PQ_Newcarservicecompaign(ModelId,Status,EntryDate) values (@ModelId,@Status,getdate()) ;  
          ELSE  
  Update PQ_Newcarservicecompaign set Status=@Status where ModelId=@ModelId;  
                
END 
