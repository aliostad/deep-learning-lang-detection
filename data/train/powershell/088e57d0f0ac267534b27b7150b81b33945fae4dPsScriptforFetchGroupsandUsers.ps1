Clear-Host


Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$credential=Get-Credential
$ctx=""
$username=$credential.UserName
$password=$credential.GetNetworkCredential().Password
$securepassword=ConvertTo-SecureString $password -AsPlainText -Force
$url="your site url"

try
{

function GetSourceGroupsandUsers()
{
$grouparray=@()
$ctx=New-Object Microsoft.SharePoint.Client.ClientContext($url)
$Credentials=New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username,$securepassword)
$ctx.Credentials=$Credentials
$web=$ctx.Web
$ctx.Load($web)
Write-Host $web.Title
$ctx.Load($web.SiteGroups)
$ctx.Load($web.SiteUsers)
$ctx.ExecuteQuery()
[Microsoft.SharePoint.Client.GroupCollection]$groupcollection=$web.SiteGroups

foreach($group in $groupcollection)
{
  $ctx.Load($group)
  $ctx.ExecuteQuery()
  $siteusers=$group.Users
  $ctx.Load($siteusers)
  $ctx.ExecuteQuery()
  foreach($user in $siteusers)
  {
  $obj=New-Object PSObject
  $login=$user.LoginName
  $obj| Add-Member -MemberType NoteProperty -Name "LoginName" $login
  $obj|Add-Member -MemberType NoteProperty -Name "Group Name" $group.Title
  $obj|Add-Member -MemberType NoteProperty -Name "Group Id" $group.Id
  $obj|Add-Member -MemberType NoteProperty -Name "User Name" $user.Title
  $grouparray+=$obj
  }
  
}
$grouparray | Export-Csv -Path "your path"
}

GetSourceGroupsandUsers

}
catch
{
$errormessage=$_.Exception.Message
$errormessage | Out-File "your path "
Write-Host "Some Error Occured"
}