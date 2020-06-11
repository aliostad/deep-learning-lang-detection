function Remove-PushBulletSubscription {
	<#
		.SYNOPSIS
		Remove a subscription
		.PARAMETER tag
		Channel tag of the subscription you would like to remove
		.PARAMETER ID
		Iden of the subscription you would like to remove
		.EXAMPLE
		Remove-PushBulletSubscriptions -Channel humblebundle
		
	  #>
	[CmdletBinding()]
	param (
	    [Parameter(Mandatory=$false)][string]$Iden,
		[Parameter(Mandatory=$false)][string]$Tag
        
)
	begin {
		# Get the apikey
		$apikey = Get-PusbhulletApiKey
		Write-Verbose "Successfully got apikey"
		if($apikey -eq $null){
			Write-Error -Message "Could not read api key" -Category ReadError
		}
		else{
			# Set the apikey in the headers.
			$headers = @{Authorization = "Bearer $apikey"}
		}
		if(!$iden){
			$iden = (Get-PushBulletSubscriptions | ? {$_.tag -match $tag}).iden
		}
	}
	
	process{
		$uri = "https://api.pushbullet.com/v2/subscriptions/" + $iden
		Write-Debug $uri
		$Requestattempt = Invoke-WebRequest -Uri $uri -Headers $headers -Method Delete
		If ($Requestattempt.StatusCode -eq "200"){
			Write-Verbose "Removed subscription successfully"
			}
		else {
			Write-Error -Message "Error: Something went wrong. Check `$attempt for info" -Category WriteError
			$global:attempt = $Requestattempt
		}

	}
}
Export-ModuleMember -Function *