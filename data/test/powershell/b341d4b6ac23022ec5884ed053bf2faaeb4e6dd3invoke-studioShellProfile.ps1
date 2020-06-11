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


param( $profile )

import-module preferencestack;
get-studioShellSettings.ps1 | push-preference;

if( -not $profile )
{
	write-debug "skipping StudioShell profile load because no profile variable is defined"
	return;
}

if( -not $profile.CurrentUserCurrentHost -and -not $profile.AllUsersCurrentHost) 
{
	write-debug "no current host profiles are defined in this shell";
	return;
}

$settings = get-studioShellSettings.ps1;

if( -not $settings )
{
	write-debug "skipping StudioShell profile load because no settings could be loaded";
	return;
}

function invoke-profile( $p )
{
	if( test-path $p )
	{
		write-debug "invoking profile script $p ...";
		. $p;
	}
	else
	{
		write-debug "skipping profile script $p because it does not exist";
	}
}

function invoke-PowerShellProfiles()
{
	if( -not( $profile | get-member PowerShellProfilesInvoked ) )
	{
		write-debug 'invoking PowerShell profiles ...'
		try
		{
			. invoke-profile $profile.CurrentUserAllHosts;
			. invoke-profile $profile.CurrentUserPowershellHost;
		}
		finally
		{
			$profile | add-member -membertype noteproperty -name PowerShellProfilesInvoked -value $true | out-null;
		}
	}
}

function invoke-StudioShellProfiles()
{
	write-debug 'invoking StudioShell profiles ...'
	. invoke-profile $profile.AllUsersCurrentHost;
	. invoke-profile $profile.CurrentUserCurrentHost;
}

if( -not( $settings.LoadPowerShellProfiles -or $settings.LoadStudioShellProfiles ) )
{
	return;
}

write-host "Please wait while the StudioShell profile scripts are run...";

if( $settings.LoadPowerShellProfiles )
{
	. invoke-PowerShellProfiles;
}
else
{
	write-debug "PowerShell profile load is disabled in StudioShell settings";
}

if( $settings.LoadStudioShellProfiles )
{
	. invoke-StudioShellProfiles;
}
else
{
	write-debug "StudioShell profile load is disabled in StudioShell settings";
}

pop-preference;
remove-module preferencestack;

<#
.SYNOPSIS 
Runs the StudioShell profile scripts.

.DESCRIPTION
Runs the StudioShell profile scripts, as specified in the StudioShell settings.

.NOTE
You typically do not need to invoke this command directly; instead, use the start-studioshell.ps1 command.

.INPUTS
None.

.OUTPUTS
None.

.LINK
about_StudioShell
about_StudioShell_Profiles
PSDTE
start-studioshell
#>
