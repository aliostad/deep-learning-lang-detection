#Add references to SharePoint client assemblies and authenticate to Office 365 site
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$Username = "admin@tenant.onmicrosoft.com"
$Site = "https://tenant.sharepoint.com/sites/sitename"
$MasterPage = "D:\MasterPage.master"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username,$Password)
$Context.Credentials = $Creds

#Bind to the Master Page Gallery
$List = $Context.Web.Lists.GetByTitle("Master Page Gallery")
$Context.Load($List)
$Context.ExecuteQuery()

#Upload the Master Page specified in the $MasterPage variable
$FileStream = New-Object IO.FileStream($MasterPage,[System.IO.FileMode]::Open)
$FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
$FileCreationInfo.Overwrite = $true
$FileCreationInfo.ContentStream = $FileStream
$FileCreationInfo.URL = $MasterPage.Split("\")[-1]
$Upload = $List.RootFolder.Files.Add($FileCreationInfo)
$Context.Load($Upload)
$Context.ExecuteQuery()
$Web = $Context.Web
$Context.Load($Web)
$Context.ExecuteQuery()

#Check the Master Page Out and then In to create a major version
$Item = $List.RootFolder.Files.GetByUrl(($Web.ServerRelativeUrl) + "/_catalogs/masterpage/" + ($MasterPage.Split("\")[-1]))
$Context.Load($Item)
$Context.ExecuteQuery()
$CheckOut = $Item.CheckOut()
$Context.ExecuteQuery()
$CheckIn = $Item.CheckIn("Upload",[Microsoft.SharePoint.Client.CheckinType]::MajorCheckIn)
$Context.ExecuteQuery()

#Set the Master Page
$Web = $Context.Web
$MasterURL = $Context.Web.ServerRelativeUrl + "/_catalogs/masterpage/" + $MasterPage.Split("\")[-1]
$WebMaster = $Web.MasterUrl = $MasterURL
$CustomMaster = $Web.CustomMasterUrl = $MasterURL
$Web.Update()
$Context.Load($Web)
$Context.ExecuteQuery()