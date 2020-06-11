function Get-PushBulletDevices {
	<#
		.SYNOPSIS
		Get a list of devices asociated with your pushbullet account.
		Enter your apikey in a file named pusbhullet.cfg, and place it in the same folder as this file.
		.EXAMPLE
		Get-PushBulletDevices
		.OUTPUT
		Returns a PSCustomObject with your devices.
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
		write-verbose "Getting devices"
		$Requestattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/devices -Method Get  -Headers $headers
		If ($Requestattempt.StatusCode -eq "200"){
			Write-Verbose "Got devices successfully"
			$Devices = ($Requestattempt.Content|Convertfrom-json).Devices
			Write-Verbose "Request returned $($Devices.Count) devices"
			Return $Devices
		}
		else {
			Write-Error -Message "Error: Something went wrong. Check `$attempt for info" -Category WriteError
			$global:attempt = $Requestattempt
		}
	}
}
Export-ModuleMember -Function *