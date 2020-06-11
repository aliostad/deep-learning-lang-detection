#Add references to SharePoint client assemblies and authenticate to Office 365 site
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$Username = ""
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Site = ""
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username,$Password)
$Context.Credentials = $Creds

#Identify Web Parts on Home.aspx
$List = $Context.Web.Lists.GetByTitle("Site Pages")
$Context.Load($List)
$Context.ExecuteQuery()
$Pages = $List.RootFolder.Files
$Context.Load($Pages)
$Context.ExecuteQuery()
$Page = $List.RootFolder.Files | Where {$_.Name -eq "Home.aspx"}
$Context.Load($Page)
$Context.ExecuteQuery()
$WPM = $Page.GetLimitedWebPartManager("Shared")
$Context.Load($WPM)
$Context.ExecuteQuery()
$WebParts = $WPM.WebParts
$Context.Load($WebParts)
$Context.ExecuteQuery()

#Remove a Web Part - this removes the first Web Part registered on the page
$WebPart = $WebParts[0]
$Context.Load($WebPart)
$Context.ExecuteQuery()
$Remove = $WebPart.DeleteWebPart()
$Context.ExecuteQuery()