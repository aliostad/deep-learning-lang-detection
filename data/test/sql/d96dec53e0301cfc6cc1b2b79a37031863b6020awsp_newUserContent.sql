IF OBJECT_ID('dbo.wsp_newUserContent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserContent
    IF OBJECT_ID('dbo.wsp_newUserContent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserContent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserContent >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  July 2003
**   Description:  Insert row in UserContent
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newUserContent
 @userId        	NUMERIC(12,0)  
,@productCode       CHAR(1)       
,@communityCode     CHAR(1)      
,@userContentType   CHAR(1)     
,@userContentDescId INT        
,@currentValue      VARCHAR(255) 
,@proposedValue     VARCHAR(255)
AS
DECLARE @return 	INT
,@dateCreated 		DATETIME

EXEC @return = wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newUserContent

INSERT UserContent
(userId            
,productCode       
,communityCode     
,userContentType   
,userContentDescId 
,dateCreated
,currentValue      
,proposedValue
)
VALUES 
(@userId            
,@productCode       
,@communityCode     
,@userContentType   
,@userContentDescId 
,@dateCreated
,@currentValue      
,@proposedValue
)

IF @@error = 0 
	BEGIN
		COMMIT TRAN TRAN_newUserContent
		RETURN 0
	END
ELSE 
	BEGIN
		ROLLBACK TRAN TRAN_newUserContent
		RETURN 99
	END
go
GRANT EXECUTE ON dbo.wsp_newUserContent TO web
go
IF OBJECT_ID('dbo.wsp_newUserContent') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserContent >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserContent >>>'
go
EXEC sp_procxmode 'dbo.wsp_newUserContent','unchained'
go
