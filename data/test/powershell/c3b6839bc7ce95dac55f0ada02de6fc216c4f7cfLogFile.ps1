
function Set-Message {

	<#

	.SYNOPSIS
		Output the message to a log file

	#>

	[CmdletBinding()]
	param (

		[Hashtable]
		[Parameter(Mandatory=$true)]
		# Structure of the message
		$structure,

		[Hashtable]
		# Hashtable containing any formatting, in this case it will be the prepend that is of interest
		$formatting,

		[System.String]
		# path to log file to append data
		$logfile

	)

	# iterate around each item in the message text
	# as this could be an object
	foreach ($line in ($structure.message.text | Out-String -Stream)) {
		
		# if there is a prepend item then use that
		if (![String]::IsNullOrEmpty($formatting.prepend)) {
			
			# invoke the prepend script block
			$results = $formatting.prepend.invoke($line)

			# if there are results add the information tot heline
			if ($results.count -gt 0 -and ($prependString = $results[0]) -is [System.String])
			{
				if ([String]::IsNullOrEmpty($formatting.tag)) {
					$line = "{0} - {1} - {2} - {3}" -f $prependString, $structure.severity, $structure.eventid, $line
				} else {
					$line = "{0} - {1} - {2} - {3} - {4}" -f $prependString, $structure.severity, $structure.eventid, $formatting.tag, $line
				}
			}
		}

		# Add the line to the log file
		Add-Content -Path $logfile -Value $line
	}


}