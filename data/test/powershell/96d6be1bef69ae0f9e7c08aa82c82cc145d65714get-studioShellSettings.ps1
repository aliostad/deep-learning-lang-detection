#
#   Copyright (c) 2011 Code Owls LLC, All Rights Reserved.
#
#   Licensed under the Microsoft Reciprocal License (Ms-RL) (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.opensource.org/licenses/ms-rl
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#


param(
	[switch] 
	# when specified, the settings are returned as a hashtable rather than a custom object
	$asHashTable
)

$mydocs = [environment]::getFolderPath( 'mydocuments' );
$settingsFile = $mydocs | join-path -child 'codeowlsllc.studioshell/settings.txt';

if( -not ( test-path $settingsFile ) )
{
	mkdir ( $settingsFile | Split-Path ) | out-null;
	$myInvocation.MyCommand.Path | split-path | Join-Path -ChildPath "..\UserProfile\settings.txt" | cp -Destination $settingsFile | Out-Null;
}

$settings = ( $settingsFile | resolve-path | Get-Content ) -join "`n" | ConvertFrom-StringData;

if( -not $settings )
{
	return;
}

if( $asHashTable )
{
	return $settings;
}
else
{
	return new-object psobject -Property $settings;
}

<#
.SYNOPSIS 
Retrieves user-level StudioShell settings.

.DESCRIPTION
Retrieves user-level StudioShell settings.

These settings are stored in the user's home folder in the following location:

~/documents/codeowlsllc.studioshell/settings.txt

.INPUTS
None.

.OUTPUTS
Object.  A hashtable or PSObject containing StudioShell user-level settings.

.EXAMPLE
C:\PS> get-studioShellSettings.ps1

Name                           Value
----                           -----
LoadPowerShellProfiles         True
StartupLogLevel                None
ConsoleChoice                  OldSkool
LoadStudioShellProfiles        True
AutoManagePerSolutionModules   True

.LINK
about_StudioShell
about_StudioShell_Settings
about_StudioShell_Profiles
get-help PSDTE

#>
