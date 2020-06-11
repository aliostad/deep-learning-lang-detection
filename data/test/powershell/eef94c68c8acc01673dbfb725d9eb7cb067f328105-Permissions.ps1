#Permissions
$web = Get-SPWeb http://intranet
$web.Groups | ft Name, Roles
$web.Roles | ft Name
$group = $web.Groups | ? {$_.Name -eq "SP2013 Intranet Members"}
$role = $web.Roles[2]

#What Permissions can we assing??
[System.Enum]::GetNames("Microsoft.SharePoint.SPBasePermissions")

#What do some levels already have?
$web = Get-SPWeb http://intranet/sites/TeamSite1
$web.RoleDefinitions["Edit"].BasePermissions


#Add/Createipconf New Permission Level

#Make sure the permission level doesn't already exists
if($web.RoleDefinitions["Site Owner"] -eq $null)
{
    # Role Definition named "Site Owner" does not yet exist
    $RoleDefinition = New-Object Microsoft.SharePoint.SPRoleDefinition
    $RoleDefinition.Name = "Site Owner"
    $RoleDefinition.Description = "Permission Level to be Used for the Site Owners Group"
 
    #Below still allows user to create subsites
    $RoleDefinition.BasePermissions = "ViewListItems, AddListItems, EditListItems, DeleteListItems, OpenItems, ViewVersions, DeleteVersions, CancelCheckout, ManagePersonalViews, ViewFormPages, AnonymousSearchAccessList, Open, ViewPages, AddAndCustomizePages, ViewUsageData, ManageSubwebs, BrowseDirectories, BrowseUserInfo, AddDelPrivateWebParts, UpdatePersonalWebParts, AnonymousSearchAccessWebLists, UseClientIntegration, UseRemoteAPIs, ManageAlerts ,CreateAlerts, EditMyUserInfo, EnumeratePermissions"
    $web.RoleDefinitions.Add($RoleDefinition)
}
 
#Display the properties for our new Permission level
$web.RoleDefinitions["Site Owner"] | Out-Host


#Create a new SharePoint Group
$web = Get-SPWeb http://intranet/sites/TeamSite1
$web.SiteGroups.Add()

#Grante Permissions to the Group
$web.SiteGroups.Add(($web.Title + " Site Owners"),$web.Site.Owner,$web.Site.Owner,"Site Owners Group")
$ownerGroup = $web.SiteGroups[($web.Title + " Site Owners")]
$ownerGroupAssignment = new-object Microsoft.SharePoint.SPRoleAssignment($ownerGroup)
$OwnerRoleDef = $web.RoleDefinitions["Site Owner"]
$ownerGroupAssignment.RoleDefinitionBindings.Add($OwnerRoleDef)
$web.RoleAssignments.Add($ownerGroupAssignment)
$web.Update()
