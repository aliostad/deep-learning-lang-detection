CREATE view [dbo].[rptMissingHireGroupDetailsView]
as
-- Created 04-Jan-10
select V.VehicleCategoryID, V.VehicleModelID, V.vehicleMakeID, V.PlateNumber,
			V.ModelYear, 
			VC.VehicleCategoryCode, VC.VehicleCategoryName, 
			VM.VehicleModelCode, VehicleModelName,
			VK.VehicleMakeCode, VK.VehicleMakeName, H.HireGroupDetailID
from vehicle v
left join HiregroupDetail h on 
h.VehicleCategoryID= v.VehicleCategoryID
and h.ModelYear = v.ModelYear
and h.VehicleModelID = v.VehicleModelID
and h.VehicleMakeID = v.vehicleMakeID
inner join VehicleCategory VC on V.VehicleCategoryID = VC.VehicleCategoryID
inner join VehicleModel VM on VM.VehicleModelID = V.vehicleModelID
inner join VehicleMake VK on VK.VehicleMakeID = V.VehicleMakeID