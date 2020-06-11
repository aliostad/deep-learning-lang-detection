###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###


Fixture "Invoke-Executable" {
	
	Given "the user wants verbose output" {
		$exe = Get-Item $(Join-Path $PSScriptRoot "bin\tsr.exe")
		$arguments = @()
		$arguments += "/output=Hello"
		
		#$VerbosePreference = "Continue"
			
		Then "it should forward the output" {
			Invoke-Executable $exe.FullName $arguments
			
			Assert-MockCalled Write-LogMessage -Exactly 1 {$Message.Trim() -eq "Hello"}

		}		
	}

}