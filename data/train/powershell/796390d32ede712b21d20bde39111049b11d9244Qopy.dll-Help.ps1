
# Copy-Files command help
@{
	command = 'Copy-Files'
	synopsis = 'A Powershell File Copy Module with CRC Check.'
	description = 'Qopy is a binary Powershell Module that provides some the functionality of XCopy, Robocopy and Teracopy with an object output for advanced reporting and auditing.'
	parameters = @{
		Destination = 'Destination Directory'
		Filter = 'Filename string filter. Accepts * and ? wildcard characters.'
		Overwrite = 'Overwrite files in the Destination if they exist.'
		Recurse = 'Copy files in all sub-directories of Source.'
		ShowProgress = 'Show a progress bar with time estimate.'
		Source = 'Source Directory'
	}
	inputs = @(
		@{
			type = ''
			description = ''
		}
	)
	outputs = @(
		@{
			type = 'Qopy.FileCopyResultsItem'
			description = 'One result item for each Source file with Size, CRC and Match properties.'
		}
	)
	notes = 'Using -ShowProgress without capturing the Cmdlet output can cause a very flashy screen.'
	examples = @(
		@{
			#title = ''
			#introduction = ''
			code = { PS C:\> $results = Copy-Files C:\users\downloads D:\filearchive -Recurse
			
			}
			remarks = 'Copy all file and files in all sub-directories of "C:\users\downloads" to "D:\filearchive".'
			test = { . $args[0] }
		}
	)
	links = @(
		@{ text = 'Qopy on Github'; URI = 'https://github.com/cdhunt/Qopy' }
	)
}
