$loadInfo1 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
$loadInfo2 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

$siteUrl =  Read-Host -Prompt "SiteURL"
$username = Read-Host -Prompt "Enter username" 
$password = Read-Host -Prompt "Enter password" -AsSecureString

$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) 
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $password) 
$ctx.Credentials = $credentials


$web = $ctx.Site.RootWeb
$ctx.Load($web)
$ctx.ExecuteQuery()