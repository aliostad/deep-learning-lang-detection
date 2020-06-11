

select  *
--INTO #tempTenants
from (select rank() over(partition by new_buildingidName order by new_buildingidName, count(New_incidentnumber) desc) Ranks
            ,new_buildingidName BuildingName
                     ,a.Name Name
                     ,SUM(CASE WHEN (i.CreatedOn > GETDATE() -90) THEN 1 ELSE 0 END) AS WO90Days
                     ,SUM(CASE WHEN (i.CreatedOn > GETDATE() -60) THEN 1 ELSE 0 END) AS WO60Days
                     ,SUM(CASE WHEN (i.CreatedOn > GETDATE() -30) THEN 1 ELSE 0 END) AS WO30Days
                     , Count(*) CountAll
                     ,b.new_buildingid
         from Incident i join Account a on i.AccountId = a.AccountId join New_buildingproperty b on b.New_buildingpropertyId=i.new_buildingid
         where i.CreatedOn >  GETDATE() -120
                     and i.SubjectIdName = 'Service Request'
                     and Name != 'General Building Maintenance'
                     --and b.new_buildingid ='087301'
                     --and new_buildingidName = '8400 Normandale Lake'--Building Name example search
                     --and @BuildingID=b.New_BuildingID --Parameter to use in code
         group by new_buildingidName,a.Name,b.new_buildingid) a
ORDER BY CountAll desc
--where s.ranks <= 5

SELECT  * FROM #tempTenants

--SELECT new_buildingid, BuildingName, Name, Ranks, WO90Days, WO60Days, WO30Days, CountAll
--INTO MREGDEVSQL2008.UNITED.dbo.[tblCRMBuildingTenants]
--FROM #tempTenants

select  new_buildingid, BuildingName, Name, Ranks, WO90Days, WO60Days, WO30Days, CountAll
from (select rank() over(partition by new_buildingidName order by new_buildingidName, count(New_incidentnumber) desc) Ranks
            ,new_buildingidName BuildingName
                     ,a.Name Name
                     ,SUM(CASE WHEN (i.CreatedOn > GETDATE() -90) THEN 1 ELSE 0 END) AS WO90Days
                     ,SUM(CASE WHEN (i.CreatedOn > GETDATE() -60) THEN 1 ELSE 0 END) AS WO60Days
                     ,SUM(CASE WHEN (i.CreatedOn > GETDATE() -30) THEN 1 ELSE 0 END) AS WO30Days
                     , Count(*) CountAll
                     ,b.new_buildingid
         from Incident i join Account a on i.AccountId = a.AccountId join New_buildingproperty b on b.New_buildingpropertyId=i.new_buildingid
         where i.CreatedOn >  GETDATE() -120
                     and i.SubjectIdName = 'Service Request'
                     and Name != 'General Building Maintenance'
                     --and b.new_buildingid ='087301'
                     --and new_buildingidName = '8400 Normandale Lake'--Building Name example search
                     --and @BuildingID=b.New_BuildingID --Parameter to use in code
         group by new_buildingidName,a.Name,b.new_buildingid) a
ORDER BY CountAll desc
