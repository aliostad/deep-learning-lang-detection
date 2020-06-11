<#

    .SYNOPSIS
    Grants a specified user rights to manage serviceConnectionPoint 
    objects under a specified computer.

    .DESCRIPTION
    Adds an allow ACEs for creating, modifying, and removing a 
    serviceConnectionPoint entries for a trustee to the security 
    descriptor of a specified Active Directory computer object.
 
    .PARAMETER Computer
    Specifies the computer on which to grant access for the given user.

    .PARAMETER User
    Specifies the user for whom to grant access.

    .EXAMPLES
    .\Grant-ServiceConnectionPointRights.ps1 -Computer TheBox -User JohnS

#>

# there is a Set-Acl issue, so we use ADSI instead
# http://social.technet.microsoft.com/Forums/en-US/winserverpowershell/thread/2fb86543-a6bc-4814-abb0-403816529c26

#Requires -Version 2.0

param
(
    [Parameter(Position = 0, Mandatory=$true)]
    $Computer,

    [Parameter(Position = 1, Mandatory=$true)]
    [Alias('Trustee')]
    $User
)

Import-Module ActiveDirectory

$ActAllow = [System.Security.AccessControl.AccessControlType]::Allow

$SiNone = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
$SiAll = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::All
$SiDescendents = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents
$SiSelfAndChildren = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::SelfAndChildren
$SiChildren = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Children

$AdrFullControl = [System.DirectoryServices.ActiveDirectoryRights]::GenericAll
$AdrGenericRead = [System.DirectoryServices.ActiveDirectoryRights]::GenericRead
$AdrRead = [System.DirectoryServices.ActiveDirectoryRights]::GenericRead
$AdrWrite = [System.DirectoryServices.ActiveDirectoryRights]::GenericWrite
$AdrDelete = [System.DirectoryServices.ActiveDirectoryRights]::Delete
$AdrReadWriteDelete = $AdrRead -bor $AdrWrite -bor $AdrDelete

$GuidEmpty = [System.Guid]::Empty
$GuidConnectionPointObject = New-Object System.Guid '{28630ec1-41d5-11d1-a9c1-0000f80367c1}'

$computer = Get-ADComputer -Identity $Computer -ErrorAction Stop
$user = Get-ADUser -Identity $User -ErrorAction Stop

$adsiObject = [ADSI]"LDAP://$($computer.distinguishedName)"

$aceObjectsCreate = New-Object System.DirectoryServices.CreateChildAccessRule($user.SID, $actAllow, $GuidConnectionPointObject, $SiNone, $GuidEmpty)
$adsiObject.PSBase.ObjectSecurity.AddAccessRule($aceObjectsCreate)

$aceObjectsDelete = New-Object System.DirectoryServices.DeleteChildAccessRule($user.SID, $actAllow, $GuidConnectionPointObject, $SiNone, $GuidEmpty)
$adsiObject.PSBase.ObjectSecurity.AddAccessRule($aceObjectsDelete)

$aceObjectsAccess = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($user.SID, $AdrReadWriteDelete, $actAllow, $SiChildren, $GuidConnectionPointObject)
$adsiObject.PSBase.ObjectSecurity.AddAccessRule($aceObjectsAccess)

$adsiObject.PSBase.CommitChanges()
