
function Load-Help {

	<#

	.SYSNOPSIS
		Attempt to load the specified help resources file

	.DESCRIPTION
		Function to load the resources file that has been specified to Write-Log or in the Set-LogParameters

	#>

	[CmdletBinding()]
	param (

		[System.String]
		# Path to the resource file
		$Path,

		[switch]
		# Denote if the recursing should stop
		$norecurse
	)

	# Set a default value for the resource
	$resource = $false

	# Is the path empty?
	# Is it valid?
	# If either of these are not true then use the one in the Logging parameters

	if (![String]::IsNullOrEmpty($path) -and (Test-Path -Path $Path)) {

		# the path exists so attempt to load it
		[xml] $resource = Get-Content -Path $Path -Raw
	
	} else {
		
		# only proceed if not norecurse
		if (!$norecurse) {

			# either the path is invalid or it is empty so attempt to get from the session
			if (![String]::IsNullOrEmpty($script:Logging.resource)) {

				# Check to see if the resource in the logging object is a string
				if ($script:Logging.resource -is [System.String]) {
				
					# call this function again
					$resource = Load-Help -Path $script:Logging.resource -Norecurse
				}

				# if the logging object is an xmldocument then set that
				if ($script:Logging.resource -is [XML.XMLDocument]) {
					$resource = $script:Logging.resource
				}		
			}
		}
	}

	# return the resource
	$resource
	

}