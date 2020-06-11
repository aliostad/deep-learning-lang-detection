###
. "$(Join-Path $PSScriptRoot '_TestContext.ps1')"
###

Fixture "Publish-Artifacts" {
	
	Given "the report exist but the user has turned off publishing" {
		Mock Write-TeamCityServiceMessage {}
		Set-Properties @{
			PublishArtifacts = $false
			GeneratedFiles = @{HtmlReport = 'TestResult.html'}
		}

		Then "it shouldn't try to publish any artifacts" {
			Publish-Artifacts
			
			Assert-MockCalled Write-TeamCityServiceMessage -Exactly 0 {$MessageName -eq 'publishArtifacts'}
		}
		
	}


}










