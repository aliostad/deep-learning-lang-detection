SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

--
-- Definition for stored procedure ReadAllInventory : 
--

--
-- Definition for stored procedure ReadAllInventory : 
--

CREATE PROCEDURE [dbo].ReadAllInventory
(@inv_actual    udd_type)

AS

/*      Read all records        */
SELECT
      inv_code   = Inventory.inv_code,
      inv_name   = Inventory.inv_name,
      inv_refgrp = ReferenceGroup.grp_name,
      inv_actual = Inventory.inv_actual,
      inv_group  = Inventory.inv_group
FROM  Inventory,
         ReferenceGroup
WHERE Inventory.inv_deleted         = 0
     AND Inventory.inv_actual      >= @inv_actual
     AND ReferenceGroup.grp_code    = Inventory.inv_group
     AND ReferenceGroup.grp_actual >= @inv_actual
     AND ReferenceGroup.grp_deleted = 0
ORDER BY
      Inventory.inv_name