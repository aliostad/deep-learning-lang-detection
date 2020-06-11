# usage:
# while ($true) { powershell .\HipChat-Listener.ps1; Start-Sleep 15 }

function main {
	# Start configuration section
	# Fill in your API token and room ID below:
	$apitoken = "API TOKEN HERE"
	$roomid = 12345
	#/ End configuration section
    
	# Hide the progress indicator for Invoke-WebRequest in the powershell window
	# For more information, see:
	# http://stackoverflow.com/questions/18770723/hide-progress-of-invoke-webrequest
	$progressPreference = 'silentlyContinue'

	# See if the script has previously ready messages, if so, obtain the last message processed
	if (Test-Path "$PSScriptRoot\HipChatLastID.txt") {
		$hipChatLastID = Get-Content "$PSScriptRoot\HipChatLastID.txt"
	}

	# Use Invoke-RestCommand to call the HipChat API
	# DisableKeepAlive prevents connections from getting stuck in CLOSE_WAIT
	try {
		$messages = Invoke-RestMethod -Timeout 10 -DisableKeepAlive -Method Get -Uri "https://api.hipchat.com/v2/room/$roomid/history/latest?auth_token=$apitoken&max-results=10&not-before=$hipChatLastID"
	}
	# If there are any exceptions, display them
	catch {
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Error $errorMessage
		Write-Error $failedItem
		exit
	}

	# Process the messages returned by the API
	foreach ($message in $messages.items | where id -ne $hipChatLastID) {
		# Find messages which start with the keyword we're listening for
		if ($message.message.StartsWith("keyword ",1)) {
			# Get the requesters name
			# You can also get their user ID using $requester = $message.from.id
			$requester = $message.from.name
			# I use a modified version of Publush-HipChatRoomMessage to post messages to the room
			# Changes were removing "from" as it didn't appear to do anything and changing the API
			# WebRequest URL to: https://api.hipchat.com/v2/room/$roomid/notification
			# See https://github.com/lholman/hipchat-ps for the original script
			Publish-HipChatRoomMessage -apitoken $apitoken -roomid $roomid -message "* Performing action - Requested by $requester" -colour yellow -notify 0
			# Ths is where you'd put the code to run when the keyword is found
			Publish-HipChatRoomMessage -apitoken $apitoken -roomid $roomid -message "* Completed action requested" -colour yellow -notify 0
		}
	}
	# Save the message ID of the newest processed message to prevent the same message from
	# being reprocessed
	$hipChatLastID = ($messages.items | Sort-Object date -Descending | Select-Object -First 1).id
	$hipChatLastID | Out-File "$PSScriptRoot\HipChatLastID.txt"
}

main
