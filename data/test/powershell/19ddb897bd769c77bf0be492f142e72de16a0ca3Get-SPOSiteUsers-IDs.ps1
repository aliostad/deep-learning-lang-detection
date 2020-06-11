#Add references to SharePoint client assemblies and authenticate to Office 365 site
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Specify Site Collection to bind to
$Site = "https://tenant.sharepoint.com/sites/Test"

#Provide Credentials and Authenticate
$Username = Read-Host -Prompt "Please enter your username"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username,$Password)
$Context.Credentials = $Creds

#Bind to Root Web
$Web = $Context.Web
$Context.Load($Web)
$Context.ExecuteQuery()

#List Users
$Users = $Context.Web.SiteUsers
$Context.Load($Users)
$Context.ExecuteQuery()
$Users | Where {$_.PrincipalType -eq "User"} | Select Title, LoginName, Id -First 10 | ft -AutoSize 