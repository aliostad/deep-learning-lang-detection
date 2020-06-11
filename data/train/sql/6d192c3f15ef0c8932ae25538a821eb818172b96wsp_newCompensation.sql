IF OBJECT_ID('dbo.wsp_newCompensation') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newCompensation
    IF OBJECT_ID('dbo.wsp_newCompensation') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newCompensation >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newCompensation >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga, Mark Jaeckle
**   Date:  September 22 2003
**   Description:  Inserts row to Compensation
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_newCompensation
 @compensationId  int
,@usageTypeId  int
,@adminUserId         int
,@dateCompensated     datetime
,@dateUnavailableFrom datetime
,@dateUnavailableTo   datetime
,@userCount           int
,@creditCount         int
,@compensationDesc    varchar(255)
AS

DECLARE @return INT
,@dateCreated DATETIME

EXEC @return = wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
BEGIN
        RETURN @return
END

BEGIN TRAN TRAN_newCompensation

INSERT INTO Compensation (
 compensationId
,usageTypeId
,adminUserId
,dateCompensated
,dateUnavailableFrom
,dateUnavailableTo
,userCount
,creditCount
,compensationDesc
,dateCreated
)
VALUES
(
 @compensationId
,@usageTypeId
,@adminUserId
,@dateCompensated
,@dateUnavailableFrom
,@dateUnavailableTo
,@userCount
,@creditCount
,@compensationDesc
,@dateCreated
)

IF @@error = 0
	BEGIN
		COMMIT TRAN TRAN_newCompensation
		RETURN 0
	END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_newCompensation
		RETURN 99
END
go
GRANT EXECUTE ON dbo.wsp_newCompensation TO web
go
IF OBJECT_ID('dbo.wsp_newCompensation') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newCompensation >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newCompensation >>>'
go
EXEC sp_procxmode 'dbo.wsp_newCompensation','unchained'
go
