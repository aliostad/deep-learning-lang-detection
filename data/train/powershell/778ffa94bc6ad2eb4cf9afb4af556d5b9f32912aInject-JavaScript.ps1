$username = "mk@mkaufmann.onmicrosoft.com" 
$password = "DaLe1sKeP0H$" 
$url      = "https://mkaufmann.sharepoint.com/sites/ALMDays"
$jsurl    = "$url/Style%20Library/AppInsights.js"


$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force 

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url) 
$clientContext.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $securePassword) 


if (!$clientContext.ServerObjectIsNull.Value) 
{ 
    Write-Host "Connected to SharePoint Online site: '$Url'" -ForegroundColor Green 
} 

$id       = "AppInsights"
$revision    = [guid]::NewGuid().ToString().Replace("-", "")
$jsLink      = "$($jsurl)?rev=$revision"
$scriptBlock = "var headID = document.getElementsByTagName('head')[0]; 
                var newScript = document.createElement('script');
                newScript.type = 'text/javascript';
                newScript.src = '$jsLink';
                headID.appendChild(newScript);"

$web = $clientContext.Web

$existingActions = $web.UserCustomActions
$clientContext.Load($existingActions)
$clientContext.ExecuteQuery()

foreach ($action in $existingActions)
{
    if ($action.Description -eq $id -and $action.Location -eq "ScriptLink")
    {
        $action.DeleteObject()
        $clientContext.ExecuteQuery()
    }
}

$newAction = $existingActions.Add()
$newAction.Description = $id
$newAction.Location = "ScriptLink"
$newAction.ScriptBlock = $scriptBlock
$newAction.Update()
$clientContext.Load($web)
$clientContext.ExecuteQuery()


