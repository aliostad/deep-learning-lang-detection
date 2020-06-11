USE MDS;

BEGIN TRY
  
BEGIN TRANSACTION LoadPifUK;


select DISTINCT
  F.SELF_ID EMITENT_ID,
  F2.SELF_ID UKPIF_ID
into #FansyPIFtoManagementCompanyMapping
from [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_SHARES S
left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES F 
    ON F.SELF_ID=S.ISSUER and F.LAST_FLAG=1  --òàê â ÔÝÍÑÈ âûòàñêèâàåòñÿ ïîñëåäíÿÿ (àêòóàëüíàÿ) èñòîðè÷åñêàÿ çàïèñü 
left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_TRUSTS TR 
    ON TR.U_FACE=F.SELF_ID
left join [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES F2 
    ON F2.SELF_ID=TR.COMPANY and F2.LAST_FLAG=1


DECLARE @EntityId int;
DECLARE @EntityTable nvarchar(max);
DECLARE @LegalEntityTable nvarchar(max);
DECLARE @ManagementCompany nvarchar(max);
DECLARE @UpdateCmd nvarchar(max);

SELECT @EntityId =ID, @EntityTable = EntityTable
FROM MDS.mdm.tblEntity
WHERE Name = 'PIF'

SELECT @LegalEntityTable = EntityTable
FROM MDS.mdm.tblEntity
WHERE Name = 'LegalEntity'

SELECT @ManagementCompany = TableColumn  
FROM MDS.mdm.tblAttribute
WHERE [Entity_ID] = @EntityId
AND Name = 'ManagementCompany'


SET @UpdateCmd = '
UPDATE mdsPIF
SET mdsPIF.'+@ManagementCompany+' = mdsUKLeg.ID

FROM [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES pif
JOIN #FansyPIFtoManagementCompanyMapping mapp
ON pif.SELF_ID = mapp.EMITENT_ID

JOIN NaviconMDM.dbo.CodesMappingDetails cdFan
ON cdFan.ClientId = pif.SELF_ID
AND cdFan.EntityName = ''PIF''
AND cdFan.ClientName = ''Fansy''
JOIN NaviconMDM.dbo.CodesMappingDetails cdNsi
ON cdNsi.MasterCode = cdFan.MasterCode
AND cdNsi.EntityName = ''PIF''
AND cdNsi.ClientName = ''NSI''
JOIN MDS.mdm.'+@EntityTable+' mdsPIF
ON mdsPIF.Code COLLATE Cyrillic_General_CI_AS = cdNsi.ClientId

LEFT JOIN [SDEPO-NAV].[X_DEPO_DATA].dbo.OD_FACES UKface
    ON mapp.UKPIF_ID = UKface.SELF_ID
LEFT JOIN NaviconMDM.dbo.CodesMappingDetails cdUKFansy
    ON cdUKFansy.ClientId = UKface.SELF_ID
    AND cdUKFansy.EntityName = ''LegalEntity''
    AND cdUKFansy.ClientName = ''Fansy''
LEFT JOIN NaviconMDM.dbo.CodesMappingDetails cdUKNSI
    ON cdUKNSI.MasterCode = cdUKFansy.MasterCode
    AND cdUKNSI.EntityName = ''LegalEntity''
    AND cdUKNSI.ClientName = ''NSI''
LEFT JOIN MDS.mdm.'+@LegalEntityTable+' mdsUKLeg
ON mdsUKLeg.Code COLLATE Cyrillic_General_CI_AS = cdUKNSI.ClientId';

EXEC sp_executesql @UpdateCmd;


INSERT INTO NaviconMDM.dbo.CodesMappingLinks
(ChildId,ParentId)
SELECT cdPifFan.DetailsId,cdLegFan.DetailsId FROM MDS.mdm.Infinitum_PIF pif
JOIN MDS.mdm.Infinitum_LegalEntity leg
ON pif.ManagementCompany_Code = leg.Code
JOIN NaviconMDM.dbo.CodesMappingDetails cdPifNsi
ON cdPifNsi.ClientId = pif.Code COLLATE Cyrillic_General_CI_AS AND cdPifNsi.EntityName = 'PIF' AND cdPifNsi.ClientName = 'NSI'
JOIN NaviconMDM.dbo.CodesMappingDetails cdPifFan
ON cdPifFan.MasterCode = cdPifNsi.MasterCode AND cdPifFan.ClientName = 'Fansy'
JOIN NaviconMDM.dbo.CodesMappingDetails cdLegNsi
ON cdLegNsi.ClientId = pif.ManagementCompany_Code COLLATE Cyrillic_General_CI_AS AND cdLegNsi.EntityName = 'LegalEntity' AND cdLegNsi.ClientName = 'NSI'
JOIN NaviconMDM.dbo.CodesMappingDetails cdLegFan
ON cdLegFan.MasterCode = cdLegNsi.MasterCode AND cdLegFan.ClientName = 'Fansy'

PRINT 'Completed'

DROP TABLE #FansyPIFtoManagementCompanyMapping;

COMMIT TRANSACTION LoadPifUK;
END TRY

BEGIN CATCH
  SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

    ROLLBACK TRANSACTION LoadPifUK;
END CATCH