CREATE PROCEDURE [dbo].[sp_SyncCarModel]
       @modelId NUMERIC(18,0),                      
       @modelname VARCHAR(30),      
       @createdon DATETIME,                  
       @createdby NUMERIC(18,0),      
       @servername VARCHAR(30),     
       @isreplicated BIT                           
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO Con_SyncModel
          ( 
            ModelId,
            ModelName,
            CreatedOn,
            CreatedBy,
            ServerName,
            IsReplicated                  
          ) 
     SELECT  @modelId,@modelname,@createdon,@createdby,@servername,@isreplicated  
     WHERE NOT EXISTS (SELECT 1 FROM Con_SyncModel WHERE ModelId=@modelId AND ModelName=@modelname) 
                 
END 


