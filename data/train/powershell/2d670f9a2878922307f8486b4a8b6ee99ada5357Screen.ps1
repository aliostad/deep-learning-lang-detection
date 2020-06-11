<#
Copyright 2014 ASOS.com Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>


function Set-Message {

	<#

	.SYNOPSIS
	Log provider to output messages to the screen

	.DESCRIPTION
	Outputs message data to the screen.  It will determine if the host can handle colours, if they have been
	specified

	#>

	[CmdletBinding()]
	param (

		[PSObject]
		[Parameter(Mandatory=$true)]
		[alias("message")]
		# Structure of the message, this contains all the date information eventid etc
		$structure,

		[int]
		# number of indents required on the output
		$indent = 0,

		[string]
		# string to use for the indent
		$indent_text = "    ",

		[string]
		# the foreground colour for the text
		$fgcolour,

		[string]
		# the background colour for the text
		$bgcolour,

		[String[]]
		# string array of consoles that support colour
		$consoles = @("ConsoleHost"),

		[switch]
		# Whether a new line should be placed on the text or not
		$nonewline,

		[bool]
		$includeEventId
	)

	# work out the indent prefix
	$indent_prefix = ""
	for ($i = 0; $i -lt $indent; $i ++) {
		$indent_prefix += $indent_text
	}

	# get the message from the structure and format it accordingly
	if ($structure.level -eq "INFO" -or $structure.level -eq "PROGRESS") {

		# format the message without the type added in
		# if the option to include the eventid is set then add this in as well
		if (!$includeEventId -or !($structure.eventid)) {
			$message = "{0}{1}" -f $indent_prefix, $structure.message.text
		} else {
			$message = "{0}({1})  {2}" -f $indent_prefix, $structure.eventid, $structure.message.text
		}

	} else {

		# fromat the message with the message level
		if ($includeEventId -and $structure.eventid) {
			$message = "{0}{1} ({2}): {3}" -f $indent_prefix, $structure.level, $structure.eventid, $structure.message.text
		} else {
			$message = "{0}{1}: {2}" -f $indent_prefix, $structure.level, $structure.message.text
		}
	}


	# anlayse the structure to see if there is any extra information, if there is
	# add it as a new line to the message with the indent as specified and an extra one
	# iterate around each of the extra information and add it as a new line to the message
	foreach ($info in $structure.message.extra) {

		# determine the line to be set, including the indent
		$line = "`n{0}{1}{2}" -f $indent_prefix, $indent_text, $info

		# add to the message
		$message += $line
	}

	# determine if running in a console or not
	# TODO: revert to using $consoles once we figure out why out custom host is not identifying itself as we expect
	#if ($consoles -icontains $Host.Name) {
	if ($Host.UI.ToString() -eq "System.Management.Automation.Internal.Host.InternalHostUserInterface") {

				# set the default colours of the back and foreground
				$current = @{
					foreground = "white"
					background = "black"
				}

        # do not try to get the current background and foreground colours for ISE
        # this is because this will return -1
        if ($host.name -notmatch "ISE") {

					# get the current fore and background colours so they can be used as defaults
          if (![String]::IsNullOrEmpty($Host.UI.RawUI.ForegroundColor)) {
				  	$current.foreground = $Host.UI.RawUI.ForegroundColor
          }

          if (![String]::IsNullOrEmpty($Host.UI.RawUI.BackgroundColor)) {
			    	$current.background = $Host.UI.RawUI.BackgroundColor
          }

        }

		    # set the colours if they have been specified in the function
		    # otherwise use the current colours
		    if ($fgcolour -eq $false -or [String]::IsNullOrEmpty($fgcolour)) {
			    $fgcolour = $current.foreground
		    }

		    if ($bgcolour -eq $false -or [String]::IsNullOrEmpty($bgcolour)) {
			    $bgcolour = $current.background
		    }

		# use the write-host function to output the message
		Write-Host -ForegroundColor $fgcolour -BackgroundColor $bgcolour -NoNewline:$nonewline $message

	} else {

		# just output the string message as a string
		Write-Verbose $message
	}

}
