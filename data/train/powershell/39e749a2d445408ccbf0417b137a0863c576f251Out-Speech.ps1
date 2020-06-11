#========================================================================
# Created on:   2/18/2014 2:42 AM
# Created by:   Guido Oliveira
# Filename:     out-speech.ps1
#========================================================================

function Out-Speech {
	<#
	.SYNOPSIS
		This is a Text to Speech Function made in powershell.

	.DESCRIPTION
		This is a Text to Speech Function made in powershell.

	.PARAMETER  Message
		Type in the message you want here.

	.PARAMETER  Gender
		The description of a the ParameterB parameter.

	.EXAMPLE
		PS C:\> Out-Speech -Message "Testing the function" -Gender 'Female'
		
	.EXAMPLE
		PS C:\> "Testing the function 1","Testing the function 2 ","Testing the function 3","Testing the function 4 ","Testing the function 5 ","Testing the function 6" | Foreach-Object { Out-Speech -Message $_ }
	
	.EXAMPLE
		PS C:\> "Testing the Pipeline" | Out-Speech

	.INPUTS
		System.String

	#>
	[CmdletBinding()]
	param(
		[Parameter(Position=0, Mandatory=$true,ValueFromPipeline=$true)]
		[System.String]
		$Message,
		[Parameter(Position=1)]
		[System.String]
		[validateset('Male','Female')]
		$Gender
	)
	begin {
		try {
			 Add-Type -Assembly System.Speech -ErrorAction Stop
		}
		catch {
			Write-Error -Message "Error loading the requered assemblies"
		}
	}
	process {
		
			$voice = New-Object -TypeName 'System.Speech.Synthesis.SpeechSynthesizer' -ErrorAction Stop
           
            Write-Verbose "Selecting a $Gender voice"
            $voice.SelectVoiceByHints($Gender)
			
			Write-Verbose -Message "Start Speaking"
            $voice.Speak($message) | Out-Null
			
	
	}
	end {
		
	}
}