#Add references to SharePoint client assemblies and authenticate to Office 365 site
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Publishing.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$Username = ""
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Site = ""
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($Site)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username,$Password)
$Context.Credentials = $Creds

$SC = $Context.Site
$Context.Load($SC)
$Context.ExecuteQuery()

#Create Blog Post
$Blog = "BlogSite"
$Web = $SC.OpenWeb($Blog)
$Context.Load($Web)
$Context.ExecuteQuery()

$List = $Web.Lists.GetByTitle("Posts")
$Context.Load($List)
$Context.ExecuteQuery()

$Title = "Title"
$Body = "Body"

$ItemInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
$Item = $List.AddItem($ItemInfo)
$Item.Set_Item("Title","$Title")
$Item.Set_Item("Body",$Body)
$Item.Update()
$Context.Load($Item)
$Context.ExecuteQuery()