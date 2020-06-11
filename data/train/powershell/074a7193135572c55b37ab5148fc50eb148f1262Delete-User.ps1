<#
.SYNOPSIS

PingID API Sample Powershell Script: Delete-User.ps1

.DESCRIPTION

This script will delete a PingID user from the PingID service. For more information, review the API documentation: https://developer.pingidentity.com/en/api/pingid-api.html

Note: This software is open sourced by Ping Identity but not supported commercially as such. Any questions/issues should go to the Github issues tracker or discuss on the Ping Identity developer communities. See also the DISCLAIMER file in this directory.

.PARAMETER UserName

The PingID user name you want to delete.

.EXAMPLE

Delete-User -UserName meredith

.LINK

https://developer.pingidentity.com
#>

param(
	[Parameter (Mandatory=$true)]
	[string]$UserName
)


#	Import PingID API helper functions
. .\pingid-api-helper.ps1


#	Create the API request and parse the results.
$apiEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/deleteuser/do"

$reqBody = @{
	"userName" = $UserName
}

$responsePayload = Call-PingID-API $reqBody $apiEndpoint


#	Retrieve the User Details to verify call
$userDetailsEndpoint = "https://idpxnyl3m.pingidentity.com/pingid/rest/4/getuserdetails/do"
$userDetailsBody = @{
	"userName" = $UserName
	"getSameDeviceUsers" = $false
}
$responsePayload = Call-PingID-API $userDetailsBody $userDetailsEndpoint
Write-Output $responsePayload
