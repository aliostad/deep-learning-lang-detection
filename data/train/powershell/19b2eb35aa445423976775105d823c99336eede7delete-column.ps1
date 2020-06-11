Write-Host "Loading the CSOM library ..."
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Publishing") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Taxonomy") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Publishing") | Out-Null
Write-Host "Successfully loaded the CSOM library."


$siteURL = "https://cityholdings.sharepoint.com/sites/performance-reviews/"  
$userId = "ven-pa@city-holdings.com.au"  
$pwd = Read-Host -Prompt "Enter password" -AsSecureString  
$creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userId, $pwd)  
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL)  
$ctx.credentials = $creds

$web = $ctx.Web
$ctx.Load($web)

$list = $web.Lists.GetByTitle("2016PR")
$ctx.Load($list)    
$ctx.ExecuteQuery()
