function Login-ToRightScale
{
	Param(
		[parameter(Mandatory=$true)] [string] $username,
		[parameter(Mandatory=$true)] [string] $password,
		[parameter(Mandatory=$true)] [string] $account
	)
	
	# Load NRightAPI.dll assembly
	[Reflection.Assembly]::LoadFile((Get-Location).Path + "\NRightAPI.dll")

	# Instantiate NRightAPI using RS Accout number
	$global:api = new-object WriteAmeer.NRightAPI($account)

	# Login to RightScale 
	$global:api.Login($username,$password)

}

Login-ToRightScale "$env:RS_USERNAME" "$env:RS_PASSWORD" "$env:RS_ACCOUNT" | Out-Null

