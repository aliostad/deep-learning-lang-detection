SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


--
-- Definition for stored procedure ReadAllPriorityType : 
--

--
-- Definition for stored procedure ReadAllPriorityType : 
--

CREATE PROCEDURE [dbo].[ReadAllPriorityType]
(@pt_actual    udd_type)

AS
   SELECT
      pt_code    = PriorityType.pt_code,
      pt_name    = PriorityType.pt_name,
      pt_actual  = PriorityType.pt_actual,
      pt_user    = PriorityType.pt_muser,
      pt_date    = PriorityType.pt_mdate,
      pt_level   = PriorityType.pt_level
   FROM  PriorityType
   WHERE PriorityType.pt_actual >= @pt_actual
     AND PriorityType.pt_deleted = 0
   ORDER BY
      PriorityType.pt_name
