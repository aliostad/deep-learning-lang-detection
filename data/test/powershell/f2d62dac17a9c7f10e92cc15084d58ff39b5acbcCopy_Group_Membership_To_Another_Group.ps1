<#
			.SYNOPSIS
			Copies Group membership from group A to group B

			.DESCRIPTION
			Asks Admin for orginal Group and new Group Names
			Gets Group Membership from orginal and copies to new
#>

# Ask admin for original group name to copy users from
$ogName= Read-host "Enter group name to copy users from"

# Ask admin for new group name to copy user to
$ngName= Read-host "Enter group name to copy users to"

# Gets original groups members
$gmembers = Get-ADGroupMember $ogName

# Copies orginal groups members to new group
Foreach($i in $gmembers.SamAccountName){ Add-ADGroupMember -Identity $ngName -Members $i}