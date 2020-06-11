function Get-PushbulletMe {
	<#
		.SYNOPSIS
		Get information about your pushbullet account
		.EXAMPLE
		Get-PushbulletMe
		.OUTPUT
		Returns details about your account
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
		write-verbose "Getting info"
		$Requestattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/users/me -Method Get  -Headers $headers
		If ($Requestattempt.StatusCode -eq "200"){
			Write-Verbose "Got Subscriptions successfully"
			$Me = ($Requestattempt.Content|Convertfrom-json)
			Return $Me
		}
		else {
			Write-Error -Message "Error: Something went wrong. Check `$attempt for info" -Category WriteError
			$global:attempt = $Requestattempt
		}
	}
}
Export-ModuleMember -Function *