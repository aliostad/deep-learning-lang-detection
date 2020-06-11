SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*  
==============================================================================  
 Copyright (c) Microsoft Corporation. All Rights Reserved.  
==============================================================================  
  
Wrapper for the udpModelSave proc.  
  
DECLARE @RC int  
DECLARE @User_ID int  
DECLARE @Model_MUID uniqueidentifier  
DECLARE @ModelName nvarchar(50)  
DECLARE @Return_ID int  
DECLARE @Return_MUID uniqueidentifier  
  
SELECT   
      @User_ID = 1  
    , @Model_MUID = '1565655D-4B03-4F64-B37F-956F75BF396D'  
    , @ModelName = 'Account (*)'  
  
EXECUTE @RC = [mdm].[udpModelSaveByMUID]   
   @User_ID  
  ,@Model_MUID  
  ,@ModelName  
  ,@Return_ID OUTPUT  
  ,@Return_MUID OUTPUT  
  
SELECT @RC  
  
*/  
CREATE PROCEDURE [mdm].[udpModelSaveByMUID]  
(  
    @User_ID		INT,  
    @Model_MUID		UNIQUEIDENTIFIER,  
    @ModelName		NVARCHAR(50),  
    @Return_ID		INT = NULL OUTPUT,  
    @Return_MUID	UNIQUEIDENTIFIER = NULL OUTPUT --Also an input parameter for clone operations  
)  
/*WITH*/  
AS BEGIN  
    SET NOCOUNT ON;  
  
    /*  
    Mode		@Model_MUID			@Return_MUID  
    --------    ------------------  ------------------  
    Create		Empty Guid or null	Empty Guid or null  
    Clone		Empty Guid or null	Guid	  
    Update		Guid				n/a  
    */  
    DECLARE @Model_ID INT,  
            @IsSystem BIT;  
  
    IF (@Model_MUID IS NOT NULL AND CAST(@Model_MUID  AS BINARY) <> 0x0)  
    BEGIN  
        -- Update Mode  
        SELECT  @Model_ID = ID FROM mdm.tblModel WHERE MUID = @Model_MUID AND IsSystem = 0;  
  
        IF @Model_ID IS NULL   
        BEGIN  
            --On error, return NULL results  
            SELECT @Return_ID = NULL, @Return_MUID = NULL;  
            RAISERROR('MDSERR200001|The model cannot be saved. The model ID is not valid.', 16, 1);  
            RETURN;  
        END;  
    END;  
  
    SET @IsSystem = 0;  -- This proc does not add or update IsSystem Models  
  
    EXEC mdm.udpModelSave @User_ID, @Model_ID, @ModelName, @IsSystem, @Return_ID OUTPUT, @Return_MUID OUTPUT;  
  
    SET NOCOUNT OFF;  
END; --proc
GO
