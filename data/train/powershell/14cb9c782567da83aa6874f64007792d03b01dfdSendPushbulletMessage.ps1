function Send-PushbulletNote {
  <#
  .SYNOPSIS
    Send pushbullet notification to your devices from PowerShell
    Enter your apikey in a file named pusbhullet.cfg, and place it in the same folder as this file.
  .DESCRIPTION
    Use PowerShell to send notification to your devices with Pushbullet.
    For now the only supported function is a text note, and it is not possible to specify devices.
  .EXAMPLE
    Send-PushbulletNote -Subject "Warning!" -Message "The coffemachine is out of coffe"
  .EXAMPLE
    Send-PushbulletNote -Subject "Message from $env:computername" -Message "User $env:username logge on to the computere"
  .EXAMPLE
    Send-PushbulletNote -Subject "To Device" -Message "Sent to specific device" -Device u1qSJddxeKwOGuGW
  .EXAMPLE
    Send-PushbulletNote -Subject "To Email" -Message "Sent to email" -Email george@georgemail.com
  .PARAMETER Subject
    This will be de subject line in your note
  .PARAMETER Message
    This will be the message in your note
  .PARAMETER Device
    Only send the push to these devices. Find the device_iden with Get-PushbulletDevices
   #>
  param
  (
        [Parameter(Mandatory=$false)][ValidateSet("Note", "File","Link")][string]$Type = "Note",
        [Parameter(Mandatory=$false)][string]$Device,
        [Parameter(Mandatory=$false)][string]$Email,
		[Parameter(Mandatory=$false)][string]$ChannelTag,
        [Parameter(Mandatory=$true,Position=0)][string]$Subject,
	    [Parameter(Mandatory=$true,Position=1)][string]$Message,
        [Parameter(Mandatory=$false,ParameterSetName="Link")][string]$url
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
	}

	process{
			switch ($Type)
			{
				"Note"{Write-Verbose "Sending a note" 
					$body = @{
						type = "note" 
						title = $Subject 
						body = $Message 
						device_iden = $Device 
						email = $Email
						channel_tag = $ChannelTag
						}
					}
				"Link"{Write-Verbose "Sending a link" 
					$body = @{
						type = "link" 
						title = $Subject 
						url = $url
						body = $Message 
						device_iden = $Device 
						email = $Email
						channel_tag = $ChannelTag
						}
					}
				"File"{Write-Verbose "Sending a file" 
					#First we need to upload the file
					file_name = $file_name
					file_type = $file_type
					$uploadrequest = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/upload-request -Method Post -Headers $headers -Body $upload_body
					
					#Then we can compose the body which the message is constructed of
					$body = @{
						type = "file" 
						body = $Message 
						device_iden = $Device 
						email = $Email
						file_name = $file_name
						file_type = $file_type
						file_url = $file_url
						channel_tag = $ChannelTag
						}
					}
				}


			Write-Verbose "Sending message"
			$Sendattempt = Invoke-WebRequest -Uri https://api.pushbullet.com/v2/pushes -Method Post  -Headers $headers -Body $body
			If ($Sendattempt.StatusCode -eq "200"){Write-Verbose "Push sent successfully"}
				else {Write-Warning "Something went wrong. Check `$attempt for info"
					  $global:attempt = $Sendattempt  }
			
		}
}
Export-Modulemember *