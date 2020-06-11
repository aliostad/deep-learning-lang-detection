function Get-TargetResource
{
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[Parameter(Mandatory)]
		[String]$Message
	)
	$returnValue = @{
		Message = $Message
        UserName = "Admin" # hardcoding here, this needs to be fetched from appropriate place
	}
	$returnValue
}


function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[String]$Message,

		[Parameter(Mandatory)]
		[PSCredential]$UserCredential
	)
    
    Write-Verbose "Message: $Message"
    Write-Verbose "Message: $($UserCredential.UserName)"
}


function Test-TargetResource
{
	[OutputType([System.Boolean])]
	param
	(
		[Parameter(Mandatory)]
		[String]$Message,

		[Parameter(Mandatory)]
		[PSCredential]$UserCredential
    )
    $false # Hello providers always returns false, that means allways SET is called.
}