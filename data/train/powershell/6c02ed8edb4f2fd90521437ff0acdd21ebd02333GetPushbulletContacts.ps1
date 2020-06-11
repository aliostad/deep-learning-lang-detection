function Get-PushbulletContacts {
	<#
		.SYNOPSIS
		Get a list of contacts asociated with your pushbullet account.
		.EXAMPLE
		Get-PushbulletContacts
		.OUTPUT
		Returns a PSCustomObject with your contacts.
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
		write-verbose "Getting contacts"
		$Requestattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/contacts -Method Get  -Headers $headers
		If ($Requestattempt.StatusCode -eq "200"){
			Write-Verbose "Got contacts successfully"
			$Contacts = ($Requestattempt.Content|Convertfrom-json).contacts
			Write-Verbose "Request returned $($Contacts.Count) contact(s)"
			Return $Contacts
		}
		else {
			Write-Error -Message "Error: Something went wrong. Check `$attempt for info" -Category WriteError
			$global:attempt = $Requestattempt
		}
	}
}
Export-ModuleMember -Function *