SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


--
-- Definition for stored procedure ReadAllStatusType : 
--

--
-- Definition for stored procedure ReadAllStatusType : 
--

CREATE PROCEDURE [dbo].[ReadAllStatusType]
(@st_actual    udd_type)

AS
   SELECT
      st_code    = StatusType.st_code,
      st_name    = StatusType.st_name,
      st_actual  = StatusType.st_actual,
      st_user    = StatusType.st_muser,
      st_date    = StatusType.st_mdate
   FROM  StatusType
   WHERE StatusType.st_actual >= @st_actual
     AND StatusType.st_deleted = 0
   ORDER BY
      StatusType.st_name
