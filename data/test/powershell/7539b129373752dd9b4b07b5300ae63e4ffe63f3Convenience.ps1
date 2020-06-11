Function Get-ShareWeb {
    [CmdletBinding()]    
	Param(
		[Parameter(Mandatory=$true)] [String] $Uri
	)
		
	
	# https://sharepoint/sites/playground/_layouts/15/start.aspx#/Lists/Reboot/AllItems.aspx
	if ($Uri -like "*/_layouts/15/start.aspx#*") {
		$Uri = $Uri.Replace("_layouts/15/start.aspx#/", "")
	}
	
	if ($Uri -match "/Lists/.*|/SiteAssets/.*") {
		$Uri = $Uri.Replace($Matches[0], "")
	}
	
	if ($Uri -notlike "*/_api/web*") {
		$Uri = "$Uri/_api/web"
	}	
	
    Write-Debug "Get-ShareWeb: $Uri"
    Invoke-XmlApiRequest -Uri $Uri -Debug:($PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent) -Verbose:($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
}

Function Get-ShareEffectivePermissionsForUser {
	<#
	.SYNOPSIS
	Query the API for effective permissions of a given user for an object (web, list, item).
	
	.PARAMETER
	
	#>

	Param(
		[Parameter(Mandatory=$true)] [String] $LoginName,
		[Parameter(Mandatory=$true)] [PSCustomObject] $Object,
		[Switch] $EnableCaching
	)
	
	# we need the web object for the users list
	$Web = Get-ShareWeb -Uri (Get-ShareRootWebUri -Object $Object)	
	
	# fetch the user object
	$User = $Web.SiteUsers({$_.LoginName -like "*$LoginName"}, $EnableCaching)
	
	if ($User -eq $null) {
		Return $null
	}
	
	# permissions can be assigned to groups as well
	$Membership = $User.Groups($null, $EnableCaching) | Select-Object -ExpandProperty "Id"
	
	#Write-Host ("User is member of: {0}" -f [String]::Join(", ", $Membership))
	
	# for each role assignemnt, check if our user is part of the members list
	# if the user is part of the list, keep the role definition for later
	$Roles = @()
	ForEach ($RA in $Object.RoleAssignments($null, $EnableCaching)) {
		$Member = $RA.Member($null, $EnableCaching)
		
		$IsGroupMember = $Member | Where-Object { $_.__Category -like 'SP.Group' -and $Membership -contains $_.Id }
		$IsDirectMember = $Member | Where-Object { $_.Id -eq $User.Id }
		
		if ($IsGroupMember -ne $null -or $IsDirectMember -ne $null) {
			$Roles += $RA.RoleDefinitionBindings($null, $EnableCaching)
		}
	}
	
	# not sure if this should return the api objects instead
	$Roles | Select-Object -Property "Order", "Id", "Name" -Unique	
}

Function Get-ShareRootWebUri {
	<#
	.SYNOPSIS
	Query the API for effective permissions of a given user for an object (web, list, item).
	
	.PARAMETER
	
	#>
	
	Param(
		[Parameter(Mandatory=$true)] [PSCustomObject] $Object
	)

	if ($Object.__Uri -match ".*/_api/web") {	
		$Matches[0]
	} else {
		Write-Error "Get-ShareRootWeb: __Uri property missing or malformed ('.*/_api/web')"
	}
}