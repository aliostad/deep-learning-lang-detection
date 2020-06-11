#Set-StrictMode -version latest
<#
package_lib.Tests.ps1
Unit / Integration tests used to validate the items in the lib folder of your app for the nuget package.

Ex.
Checking to see if a lib file exists
Checking to see if a lib file is a particular architecture

#>

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