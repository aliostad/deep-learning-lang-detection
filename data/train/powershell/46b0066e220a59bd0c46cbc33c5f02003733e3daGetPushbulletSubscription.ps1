function Get-PushBulletSubscriptions {
	<#
		.SYNOPSIS
		Get a list of Subscriptions asociated with your pushbullet account.
		Enter your apikey in a file named pusbhullet.cfg, and place it in the same folder as this file.
		.EXAMPLE
		Get-PushBulletSubscriptions
		.OUTPUT
		Returns a PSCustomObject with your Subscriptions.
	  #>
	[CmdletBinding()]
	param ()
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
	}

	process{
		write-verbose "Getting Subscriptions"
		$Requestattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/subscriptions -Method Get  -Headers $headers
		If ($Requestattempt.StatusCode -eq "200"){
			Write-Verbose "Got Subscriptions successfully"
			$Subscriptions = ($Requestattempt.Content|Convertfrom-json).Subscriptions.Channel
			Write-Verbose "Request returned $($Subscriptions.Count) Subscriptions"
			Return $Subscriptions
		}
		else {
			Write-Error -Message "Error: Something went wrong. Check `$attempt for info" -Category WriteError
			$global:attempt = $Requestattempt
		}
	}
}
Export-ModuleMember -Function *