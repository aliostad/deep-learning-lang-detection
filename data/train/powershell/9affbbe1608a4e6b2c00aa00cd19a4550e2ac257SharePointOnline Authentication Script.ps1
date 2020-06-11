$bindir= "C:\Program Files\AvePoint\DocAve6\Agent\bin\2013\"
[System.Reflection.Assembly]::LoadFrom($bindir +"Microsoft.SharePoint.Client.dll")
[System.Reflection.Assembly]::LoadFrom($bindir +"Microsoft.SharePoint.Client.Runtime.dll")


$siteUrl="https://simmon6.sharepoint.com"
$userName= "cheng.cui@simmon6.onmicrosoft.com"

Write-Host "Please input password"

$pwd = Read-Host -AsSecureString

$context = New-Object Microsoft.SharePoint.Client.ClientContext $siteUrl
$credentail = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName,$pwd)
$context.Credentials = $credentail 


$context.Load($context.Web)
$context.ExecuteQuery()

$context.Web.Id

Read-Host