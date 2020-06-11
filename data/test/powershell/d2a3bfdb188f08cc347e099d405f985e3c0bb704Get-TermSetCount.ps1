#Add references to SharePoint client assemblies and authenticate to Office 365 site - required for CSOM
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Taxonomy.dll"
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking -ErrorAction SilentlyContinue

#Specify tenant admin and URL
$User = Read-Host -Prompt "Please enter your username"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Tenant = Read-Host -Prompt "Please enter tenant name e.g. ContosoO365"
$AdminURI = "https://$Tenant-admin.sharepoint.com"
$Site = "https://$Tenant.sharepoint.com"
$Creds2 = New-Object System.Management.Automation.PSCredential $User, $Password
Connect-SPOService -Url $AdminURI -Credential $Creds2

#Bind to MMS
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context.Credentials = $Creds
$MMS = [Microsoft.SharePoint.Client.Taxonomy.TaxonomySession]::GetTaxonomySession($Context)
$Context.Load($MMS)
$Context.ExecuteQuery()

#Retrieve Term Stores
$TermStores = $MMS.TermStores
$Context.Load($TermStores)
$Context.ExecuteQuery()

#Bind to Term Store
$TermStore = $TermStores[0]
$Context.Load($TermStore)
$Context.ExecuteQuery()

#Retrieve Groups
$Groups = $TermStore.Groups
$Context.Load($Groups)
$Context.ExecuteQuery()

#Retrieve TermSets in each group - GLOBAL
Write-Host "Global Term Sets" -ForegroundColor Green
Foreach ($Group in $Groups)
    {
    $Context.Load($Group)
    $Context.ExecuteQuery()
    Write-Host "Group Name:" $Group.Name -ForegroundColor Yellow
    $TermSets = $Group.TermSets
    $Context.Load($TermSets)
    $Context.ExecuteQuery()
    Write-Host "      Term Set Count:"$TermSets.Count -ForegroundColor White
    }

Write-Host "Site Collection Term Sets" -ForegroundColor Green

#Retrieve list of SPO Sites
$SPOSites = Get-SPOSite


Foreach ($SPOSite in $SPOSites)
{
Write-Host "Site:" $SPOSite.url -ForegroundColor Yellow
#Bind to MMS
Try {
$Context2 = New-Object Microsoft.SharePoint.Client.ClientContext($SPOSite.url)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context2.Credentials = $Creds
$MMS = [Microsoft.SharePoint.Client.Taxonomy.TaxonomySession]::GetTaxonomySession($Context2)
$Context2.Load($MMS)
$Context2.ExecuteQuery()

#Retrieve Term Stores
$TermStores = $MMS.TermStores
$Context2.Load($TermStores)
$Context2.ExecuteQuery()

#Bind to Term Store
$TermStore = $TermStores[0]
$Context2.Load($TermStore)
$Context2.ExecuteQuery()

#Retrieve Site Collection Term Sets
$SCGroup = $TermStore.GetSiteCollectionGroup($Context2.Site,$false)
$Context2.Load($SCGroup)
$Context2.ExecuteQuery()
$SCTermSets = $SCGroup.TermSets
$Context2.Load($SCTermSets)
$Context2.ExecuteQuery()
Write-Host "      Term Set Count:" $SCTermSets.Count -ForegroundColor White
}
Catch {
Write-Host "      Problem accessing Site Collection or No Term Sets Found" -ForegroundColor Red
}
}