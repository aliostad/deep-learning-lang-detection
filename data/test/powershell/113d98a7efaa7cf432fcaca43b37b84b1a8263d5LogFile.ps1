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
	Output the message to a file

	#>

	[CmdletBinding()]
	param (

		[PSObject]
		[Parameter(Mandatory=$true)]
		[alias("message")]
		# Structure of the message, this contains all the date information eventid etc
		$structure,

		[bool]
		# Controls whether to include the LogLevel in the logged message
		$includeLogLevelPrefix,

		[int]
		# number of indents required on the output
		$indent = 0,

		[string]
		# string to use for the indent
		$indent_text = "    ",

		[string]
		# path to log directory
		$logdir = ".",

		[string]
		# filename of the log fil
		$logfilename
	)

	# if the filename is empty then come up with a temporary name, based
	# on the current time
	if ([String]::IsNullOrEmpty($logfilename)) {
		$logfilename = "{0}.log" -f (Get-Date -Format "yyyyMMdd_HHmmss")
	}

	# Determine the path to the log file
	$path = "{0}\{1}" -f $logdir, $logfilename

	# set the content, to be extracted from the structure
	if ($includeLogLevelPrefix) {
		if ($structure.eventid) {
			$message = "[{0}] - {1} - {2} - {3}" -f $structure.timestamp, $structure.level, $structure.eventid, $structure.message.text
		}
		else {
			$message = "[{0}] - {1} - {2}" -f $structure.timestamp, $structure.level, $structure.message.text
		}
	}
	else {
		if ($structure.eventid) {
			$message = "[{0}] - {1} - {2}" -f $structure.timestamp, $structure.eventid, $structure.message.text
		}
		else {
			$message = "[{0}] - {1}" -f $structure.timestamp, $structure.message.text
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

	# Only attempt to add to the file if the parent directory exists
	if (![String]::IsNullOrEmpty(($logdir))) {
		if (Test-Path -Path $logdir) {
			Add-Content -Path $path -Value $message
		}
	}

}
