#Set-StrictMode -version latest
$modulesPath = (Split-Path -parent $MyInvocation.MyCommand.Path).Replace("\tests", "\modules\")
Import-Module (Join-Path $modulesPath global_config.psm1) -Force

    Describe "package_lib" {
		
		It "checks to see if lib\NewRelic.Api.Agent.dll exists" {
			(Test-Path $PackageRoot\lib\NewRelic.Api.Agent.dll) | Should Be $true
		}
		
		It "checks to see if lib\NewRelic.Api.Agent.dll is architecture x86" {
			Get-PEArchitecture $PackageRoot\lib\NewRelic.Api.Agent.dll | Should Be "X86"
		}
		
    }