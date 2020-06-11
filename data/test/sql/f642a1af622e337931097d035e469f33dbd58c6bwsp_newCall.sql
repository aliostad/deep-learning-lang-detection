IF OBJECT_ID('dbo.wsp_newCall') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newCall
    IF OBJECT_ID('dbo.wsp_newCall') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newCall >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newCall >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Yan Liu
**   Date:  July 2003
**   Description:  Insert row into Call
**
** REVISION(S):
**   Author:  Yan Liu
**   Date:  February 9, 2005
**   Description: Add siteId into the call log
**
******************************************************************************/
CREATE PROCEDURE wsp_newCall
    @siteId INT,
    @callId INT,
    @payId  NUMERIC(12, 0)
AS

BEGIN
    DECLARE @return      INT,
            @dateCreated DATETIME

    EXEC @return = wsp_GetDateGMT @dateCreated OUTPUT
    IF @return != 0
        BEGIN
            RETURN @return
        END

    BEGIN TRAN TRAN_newCall
    INSERT INTO Call(siteId, 
                     callId, 
                     payId, 
                     dateCreated)
    VALUES(@siteId, 
           @callId,
           @payId,
           @dateCreated)

    IF (@@error = 0)
        BEGIN
            COMMIT TRAN TRAN_newCall
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newCall
            RETURN 99
        END
END
go

IF OBJECT_ID('dbo.wsp_newCall') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newCall >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newCall >>>'
go

EXEC sp_procxmode 'dbo.wsp_newCall','unchained'
go

GRANT EXECUTE ON dbo.wsp_newCall TO web
go
