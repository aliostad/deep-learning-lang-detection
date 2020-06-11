Add-PSSnapin ShareFile

################################################################################
# UpdateRoles.ps1
#
# This script will update the roles for a specified user by email address.
#

#Run the following interactively to create a login token that can be used by Get-SfClient in unattended scripts
#$sfClient = New-SfClient -Name ((Join-Path $env:USERPROFILE "Documents") + "\YourSubdomain.sfps") -Account YourSubdomain
$sfClient = Get-SfClient -Name ((Join-Path $env:USERPROFILE "Documents") + "\YourSubdomain.sfps")


#get a user by email address
$user = Send-SfRequest -Client $sfClient -Method GET -Entity Users -Parameters @{"emailaddress" = "sample@email.com"} 

#update user roles to add all permissions
Send-SfRequest -Client $sfClient -Method PATCH -Entity Users -Navigation Roles -Id $user.Id -BodyText '
{ "Roles" : [
    "CanChangePassword",
    "CanManageMySettings",
    "CanUseFileBox",
    "CanManageUsers",
    "CanCreateFolders",
    "CanUseDropBox",
    "CanSelectFolderZone",
    "CreateNetworkShareConnectors",
    "CreateSharePointConnectors",
    "AdminAccountPolicies",
    "AdminBilling",
    "AdminBranding",
    "AdminChangePlan",
    "AdminFileBoxAccess",
    "AdminManageEmployees",
    "AdminRemoteUploadForms",
    "AdminReporting",
    "AdminSharedDistGroups",
    "AdminSharedAddressBook",
    "AdminViewReceipts",
    "AdminDelegate",
    "AdminManageFolderTemplates",
    "AdminEmailMessages",
    "AdminSSO",
    "AdminSuperGroup",
    "AdminZones",
    "AdminCreateSharedGroups",
    "AdminConnectors"
]}'
