#Add references to SharePoint client assemblies and authenticate to Office 365 site
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Authenticate to Site
$Username = Read-Host -Prompt "Please enter your username"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Site = "https://tenant.sharepoint.com"
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username,$Password)
$Context.Credentials = $Creds

#Retrieve the time zones that are available
$TZs = $Context.Web.RegionalSettings.TimeZones
$Context.Load($TZs)
$Context.ExecuteQuery()

#Update the timezone
$RegionalSettings = $Context.Web.RegionalSettings
$Context.Load($RegionalSettings)
$Context.ExecuteQuery()
$TZ = $TZs | Where {$_.Description -eq "(UTC+13:00) Samoa"}
$Update = $RegionalSettings.TimeZone = $TZ
$Context.Web.Update()
$Context.ExecuteQuery()