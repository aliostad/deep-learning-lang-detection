function New-WorkLog {
	<#
	.SYNOPSIS
		Creates daily work log file in the specified directory
	.DESCRIPTION
		Creates daily work log file in the specified directory.

		If the file already exists, a warning message is displayed and the file is not overwritten
	.PARAMETER Path
		Path to your WorkLog working directory
	.INPUTS
		System.String
	.EXAMPLE
		New-WorkLog
	.NOTES
		20150205	K. Kirkpatrick
		[+] Created
	#>

	[cmdletbinding()]
	param (
		[parameter(Mandatory = $false)]
		[System.String]$Path = "$ENV:USERPROFILE\Documents\GitHub\WorkLog"
	)

	BEGIN {

		$now = Get-Date
		$dateFormat = $now.tostring('yyyyMMdd')
		$dateDay = $now.tostring('dddd')
		$fileName = $dateFormat + '_' + $dateDay + '_' + 'WL.md'
		$filePath = Join-Path $Path $fileName
		$nowLong = $now.tostring('D')

	} # end BEGIN block

	PROCESS {

		if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {

			try {

				Write-Verbose -Message 'Creating worklog file'
				New-Item -Path $filePath -Type File -ErrorAction 'Stop' | Out-Null

				Write-Verbose -Message 'Adding message to Work Log'
				Write-Output -InputObject '## Work Log ' | Out-File -LiteralPath $filePath -Append
				Write-Output -InputObject "### $nowLong" | Out-File -LiteralPath $filePath -Append
				Write-Output -InputObject ' ' | Out-File -LiteralPath $filePath -Append
				Write-Output -InputObject '* ' | Out-File -LiteralPath $filePath -Append

				if (Test-Path -LiteralPath $filePath -PathType Leaf) {

					Write-Verbose -Message 'Work Log file created successfully'

				} else {

					Write-Verbose -Message 'Work Log file not created'

				} # end if/else Test-Path

			} catch {

				Write-Warning -Message "Error creating work log file. $_"

			} # end try/catch
		} else {

			Write-Warning -Message 'Worklog for today has already been created'

		} # end if/else

	} # end PROCESS block

	END {

		# finish things up

	} # end END block

} # end function New-WorkLog
Export-ModuleMember -Function New-WorkLog


function Add-WorkLog {
	<#
	.SYNOPSIS
		Adds a string of text and appends it to the current day's work log markdown file
	.DESCRIPTION
		Adds a string of text and appends it to the current day's work log markdown file.

		This is to be used when you want to quickly add a new bulleted point/entry to the work log file.

		If the daily worklog file has not yet been created, it will create the file and populate the first entry

		You can also specify an indentation level, with support up to 4 nested bullet levels
	.PARAMETER Message
		Update/message string that is to be appended to the work log file
	.PARAMETER Path
		Path to Work Log working directory
	.PARAMETER Indent
		The indent level you wish to specify
	.INPUTS
		System.String
	.EXAMPLE
		Add-WorkLog "Created 'WorkLog' PowerShell Module"
	.EXAMPLE
		Add-WorkLog 'Made changes to support indentation' -Indent 1

		The result of this would be a sub-bullet of the output generated in the first example:

	* Created 'WorkLog' PowerShell Module
		* Made changes to support indentation
	.NOTES
		20150205	K. Kirkpatrick
			[+] Created
	#>

	[cmdletbinding()]
	param (
		[parameter(Mandatory = $true,
				   Position = 0)]
		[System.String]$Message,

		[parameter(Mandatory = $false,
				   Position = 1)]
		[System.String]$Path = "$ENV:USERPROFILE\Documents\GitHub\WorkLog",

		[parameter(Mandatory = $false,
				   Position = 2)]
		[ValidateSet('1', '2', '3', '4')]
		[System.String]$Indent
	)

	BEGIN {

		$now = Get-Date
		$dateFormat = $now.tostring('yyyyMMdd')
		$dateDay = $now.tostring('dddd')
		$fileName = $dateFormat + '_' + $dateDay + '_' + 'WL.md'
		$filePath = Join-Path $Path $fileName
		$nowLong = $now.tostring('D')

		function Add-Indent {
			[cmdletbinding()]
			param (
				[parameter(Mandatory = $true)]
				[System.String]$Level
			)

			switch ($Level) {
				'1' { '  * ' }
				'2' { '    * ' }
				'3' { '      * ' }
				'4' { '        * ' }
			} # end switch

		} # end function indent

	} # end BEGIN block

	PROCESS {

		if (Test-Path -LiteralPath $filePath) {
			<#
			- Properly indent the message, if a value was passed to the -Indent param,
			  otherwise just append the message with the default 'root' bullet point

			- If the work log file doesn't exist, create it
			- Since the log file didn't exist, if -Indent was used, you don't want the first entry to be indented, so, ignore -Indent but let the user know
			- Append the message supplied to the default indent level (none), after the file is created
			#>

			if ($Indent) {

				$indentMessage = $(Add-Indent -Level $Indent) + $Message
				Write-Verbose -Message 'Adding message to Work Log'
				Write-Output -InputObject $indentMessage | Out-File $filePath -Append

			} else {

				Write-Verbose -Message 'Adding message to Work Log'
				Write-Output -InputObject "* $Message" | Out-File $filePath -Append

			} # end if/else $Indent

		} elseif (-not (Test-Path -LiteralPath $filePath)) {

			Write-Warning -Message 'Work log not created. Attempting to create file'
			try {

				Write-Verbose -Message 'Creating worklog file'
				New-Item -Path $filePath -Type File -ErrorAction 'Stop' | Out-Null

				if ($Indent) {

					Write-Warning -Message "Since the file has not be created, your '-Indent' input of '$Indent' will be ignored for the first log entry."

				} # end if $Indent

				Write-Verbose -Message 'Adding message to Work Log'
				Write-Output -InputObject '## Work Log ' | Out-File -LiteralPath $filePath -Append
				Write-Output -InputObject "### $nowLong" | Out-File -LiteralPath $filePath -Append
				Write-Output -InputObject ' ' | Out-File -LiteralPath $filePath -Append
				Write-Output -InputObject "* $Message" | Out-File -LiteralPath $filePath -Append

				if (Test-Path -LiteralPath $filePath -PathType Leaf) {

					Write-Verbose -Message 'Work Log file created successfully'

				} else {

					Write-Verbose -Message 'Work Log file not created'

				} # end if/else

			} catch {

				Write-Warning -Message "Error creating work log file. $_"

			} # end try/catch

		} # end if/elseif

	} # end PROCESS block

	END {

		# finish things up

	} # end END block

} # end function Add-WorkLog
Export-ModuleMember -Function Add-WorkLog


function Get-WorkLog {
	<#
	.SYNOPSIS
		Get the contents of the current Work Log file
	.DESCRIPTION
		Using Get-Content, get the contents of the current Work Log file
	.PARAMETER Path
		Working directory of Work Log Files
	.INPUTS
		System.String
	.EXAMPLE
		Get-WorkLog
	.NOTES
		20150205	K. Kirkpatrick
		[+] Created
	#>

	[cmdletbinding()]
	param (
		[parameter(Mandatory = $false)]
		[System.String]$Path = "$ENV:USERPROFILE\Documents\GitHub\WorkLog"
	)

	BEGIN {

		$now = Get-Date
		$dateFormat = $now.tostring('yyyyMMdd')
		$dateDay = $now.tostring('dddd')
		$fileName = $dateFormat + '_' + $dateDay + '_' + 'WL.md'
		$filePath = Join-Path $Path $fileName

	} # end BEGIN block

	PROCESS {

		if (Test-Path -LiteralPath $filePath -PathType Leaf) {

			Get-Content -LiteralPath $filePath -ReadCount 0

		} else {

			Write-Warning -Message 'Work Log file has not been created'

		} # end if/else

	} # end PROCESS block

	END {

		# finish things up

	} # end END block

} # end function Get-WorkLog
Export-ModuleMember -Function Get-WorkLog