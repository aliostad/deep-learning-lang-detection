
function Format-Message {

	<#

	.SYNOPSIS
		Put the message into a object

	.DESCRIPTION
		Each message that is logged with the Logging module will be added to a structure
		so that it can be passed to the providers with all the information attached

	#>

	[CmdletBinding()]
	param (

		[System.String]
		# The level at which the message should be set
		$level,

		[System.String]
		# Event ID associated with the message
		$eventid,

		[int]
		# Severity of the message
		$severity,

		# Message to be added to the object
		$message,

		[System.String]
		# Extra information to be assigned to the message
		# If the message contains subsitution placeholders then this will be injected
		$extra
	)


	# Create the object
	$structure = @{

					# Set the hostname of the machine
					hostname = [System.Net.DNS]::GetHostByName(($env:COMPUTERNAME)).Hostname
					
					# Set the eventid on the object which relates to the message
					eventid = $eventid

					# set the level for the message
					level = $level

					# add the severity
					severity = $severity

					# set the date stamp
					timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")

					# add the message information
					message = @{

						# text of the message
						text = $message.text

					}

				  }

	# If any extra information has been passed in the messahe object add it
	if ($message.containskey("extra")) {
		$structure.message.extra = $message.extra
	}

	# Return the structure
	$structure

}