# Load SharePoint SnapIn   
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)   
 {   
     Add-PSSnapin Microsoft.SharePoint.PowerShell   
 }   
 # Load SharePoint Object Model   
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")   
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Office.Policy")
 
 function ApplySiteCollectionAuditSettings($siteUrl, $auditLogTrimmingRetention, $auditReportStorageLocation){
 
	$spSite = Get-SPSite $siteUrl 
	
	$spSite.TrimAuditLog = $True
	$spSite.AuditLogTrimmingRetention = $auditLogTrimmingRetention
	
	# Store audit logs to the document library called "AuditLogs"	
	[Microsoft.Office.RecordsManagement.Reporting.AuditLogTrimmingReportCallout]::SetAuditReportStorageLocation($spSite, $auditReportStorageLocation)
 
	$spSite.Audit.AuditFlags = ([Microsoft.SharePoint.SPAuditMaskType]::All `
 							-bxor[Microsoft.SharePoint.SPAuditMaskType]::View `
							-bxor[Microsoft.SharePoint.SPAuditMaskType]::Search `
							-bxor[Microsoft.SharePoint.SPAuditMaskType]::SecurityChange `
							-bxor[Microsoft.SharePoint.SPAuditMaskType]::ProfileChange)

	$spSite.Audit.Update()
	$spSite.Dispose()
 }
 
 ApplySiteCollectionAuditSettings 	-siteUrl "http://sp2010riyaz:3877/Contracts" `
 									-auditLogTrimmingRetention 730 `
									-auditReportStorageLocation "AuditLogs"