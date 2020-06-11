#requires -Version 2.0

Set-StrictMode -Version Latest

Push-Location $psScriptRoot
. ./Api.ps1
. ./Shared.ps1
. ./External.ps1
. ./CustomObjects.ps1
. ./Project.ps1
. ./BuildType.ps1
. ./Build.ps1
Pop-Location

$script:g_TeamcityCredentials = $null
$script:g_TeamcityApiBase = $null
$script:g_TeamcityGuestAuth = $null

#Api.ps1
Export-ModuleMember Set-TeamcityApiBaseUrl
Export-ModuleMember New-TeamcityApiUrl
Export-ModuleMember Set-TeamcityCredentials
Export-ModuleMember Reset-TeamcityCredentials
Export-ModuleMember Set-TeamcityGuestAuth
Export-ModuleMember Reset-TeamcityGuestAuth
Export-ModuleMember Invoke-TeamcityGetCommand
Export-ModuleMember Invoke-TeamcityPostCommand
Export-ModuleMember Invoke-TeamcityPutCommand
Export-ModuleMember Invoke-TeamcityDeleteCommand

#Project.ps1
Export-ModuleMember Get-AllProjects
Export-ModuleMember Get-Project

#BuildType.ps1
Export-ModuleMember Get-AllBuildTypes
Export-ModuleMember Get-BuildType

#Build.ps1
Export-ModuleMember Get-AllBuilds
Export-ModuleMember Get-Build

#CustomObjects.ps1
Export-ModuleMember New-BuildType
Export-ModuleMember New-Project
Export-ModuleMember New-Dependency
Export-ModuleMember New-PropertyGroup
Export-ModuleMember New-Feature
Export-ModuleMember New-Trigger

#Shared.ps1
Export-ModuleMember Get-Parameter
Export-ModuleMember Get-AllParameters
