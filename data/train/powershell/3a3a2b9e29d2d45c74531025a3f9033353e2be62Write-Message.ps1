Function Write-Message {
	<#
		.SYNOPSIS
			Writes message to both Host and File in log format ([08-05-2015 10:26:57] Script.ps1: $message)

		.DESCRIPTION
			Writes message to both Host and File in log format ([08-05-2015 10:26:57] Script.ps1: $message)
			has support for -NoNewLine in both Console and file -ForegrounColor displays color only in console
			
		.PARAMETER Message
			Message to display in the console.
			
		.PARAMETER FilePath
			Specifies the path to the output file.
		
		.PARAMETER NoNewline
    		Specifies that the content displayed in the console does not end with a newline character.

		.PARAMETER NoLog
    		Specifies that the content is displayed in the console only
			
		.PARAMETER NoInfo
    		Specifies that the content displayed in the console does not start with ([date] filename.ps1:) usefull with the -NoNewLine Switch
			
		.EXAMPLE
			PS C:\> Write-Message "Sample message" -ForegroundColor Green
			[11-05-2015 04:52:47] : Sample message


		.EXAMPLE
			PS C:\> "Sample message from pipe | Write-Message -ForegroundColor Red -NoNewLine
			[11-05-2015 04:52:47] : Sample message from pipe

		.INPUTS
			Object

		.LINK
			http://www.proxx.nl/
	#>
	Param(
		[Parameter(Position=0, ValueFromPipeline=$true)]$Message,
		[Alias("Color")][ConsoleColor]$ForegroundColor, 
		[Switch] $NoLog, 
		[String]$FilePath,
		[Switch] $NoNewline, 
		[Switch] $NoInfo
	)
	
	$Wh = @{}
	if ($ForegroundColor) { $Wh.ForegroundColor = $ForegroundColor }
	
	if (!$NoInfo) { $Message = (Get-Date -Format "[dd-MM-yyyy hh:mm:ss] ") + [System.IO.Path]::GetFileName($myinvocation.ScriptName) + ": " + $Message}
	if ($NoLog) { 
		Write-Host $Message @Wh
	} Else {
		if (!($FilePath)) {
			$FilePath = ($MyInvocation.PSScriptRoot + "\" + [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.ScriptName) + ".log")
			if ($FilePath -eq "\.log") { throw "No file specified!" }
		}
		if ($NoNewline) { 
			$Wh.NoNewline = $true
			[System.IO.File]::AppendALlText($FilePath, $Message, [System.Text.Encoding]::Unicode)
			Write-Host $Message @Wh
		}
		Else {
			$Message | Out-File -Append -FilePath $FilePath
			Write-Host $Message @Wh
		}
	}
}
