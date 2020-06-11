

#Load Library
Add-Type -Path 'C:\Users\michael\Documents\GitHub\RightScaleNetAPI\RightScale.netClient\RightScale.netClient\bin\Debug\RightScale.netClient.dll'

#-----START:  FUNCTIONS--------------
function connect-RightScale
{

<#
.SYNOPSIS
	Connect and authenticate to RightScale
.DESCRIPTION
	Before using the API you must be connected and authenticated to RightScale
.PARAMETER $username
    RightScale username
.PARAMETER $password
	RightScale password
.PARAMETER $accountid
  	RightScale account ID
.EXAMPLE
	connect-RightScale -username mike -password mikespassword -accountid 1111
#>

[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)][string]$username, [parameter(Mandatory = $true)][string]$password,[parameter(Mandatory = $true)][string]$accountid
	)

	[RightScale.netClient.Core.APIClient]::Instance.Authenticate($username, $password, $accountid)
}

#-----END:  FUNCTIONS--------------


