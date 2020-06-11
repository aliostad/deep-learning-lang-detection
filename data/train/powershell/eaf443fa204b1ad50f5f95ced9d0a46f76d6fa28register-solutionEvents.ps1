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


$script:perSolutionScripts = @();
$script:currentSolutionModule;
	     
function clear-SolutionScriptRepository()
{
	try
	{
		write-debug 'clearing per-solution script repository';
		
		$script:path = $env:path;
				
		$script:perSolutionScripts | %{ 
			$script:re = [Regex]::escape( "$_;" );
			write-debug "removing script path $_";
			write-debug $script:re;
			
			$script:path = $script:path -replace $script:re,'';
		};
		
		$script:perSolutionScripts = @();

		write-debug "updating environment path";
		$env:path = $script:path;
	}
	catch
	{
		write-debug 'an error has occurred...';
		$_ | out-host;
	}

}

function update-SolutionScriptRepository()
{
	try
	{
		write-debug 'updating per-solution script repository';
		
		$script:sln = get-item dte:/solution;		
		$script:path = $env:path;
					
		if( $script:sln.FileName )
		{
			$script:sln.FileName | split-path | join-path -child 'studioShellScripts' | %{ 
				write-debug "processing $($_.PSPath)";
				$script:perSolutionScripts += $_;
				$script:path = $_ + ";" + $script:path;
				write-debug "processing complete";
			};
		}					
	
		write-debug "updating environment path";
		$env:path = $script:path;
	}
	catch
	{
		write-debug 'an error has occurred...';
		$_ | out-host;
	}
}

function get-solutionModulePath
{
	$local:solutionFilePath = get-item dte:/solution;

	$local:solutionModulePath = $local:solutionFilePath.FullName -replace '.sln','.psm1';
	
	if( -not $local:solutionModulePath )
	{
		write-verbose "no solution is currently loaded";
		return;
	}
		
	write-verbose "solution module PSM path: $local:solutionModulePath";
	if( -not( test-path $local:solutionModulePath ) )
	{
		$local:solutionModulePath = $local:solutionFilePath.FullName -replace '.sln','.psd1';
		write-verbose "solution module PSD path: $local:solutionModulePath";
	}
	
	if( -not( test-path $local:solutionModulePath ) )
	{
		write-verbose "no solution module file was found in this solution";
		return;
	}
	
	$local:solutionModulePath;
}

function get-solutionModuleName
{
	$local:solutionFilePath = get-item dte:/solution;
	( $local:solutionFilePath.FullName | split-path -leaf ) -replace '.sln','';
}

function import-solutionModule
{
	$local:slnModulePath = get-solutionModulePath;
	write-debug "checking for existence of solution module at '$local:slnModulePath' ...";
	if( -not $local:slnModulePath )
	{
		write-verbose "no solution module was found at '$local:slnModulePath'";
		return;
	}
	
	write-verbose "importing module at '$local:slnModulePath' ...";

	$script:currentSolutionModule = import-module $local:slnModulePath -passthru;
}

function remove-solutionModule
{
	if( $script:currentSolutionModule )
	{
		write-verbose "attempting to invoke unregister-$($script:currentSolutionModule.Name)";
		$cmdName = "unregister-$($script:currentSolutionModule.Name)";
		get-command -module $script:currentColutionModule.Name -name $cmdName | 
			select -expand Name | 
			invoke-expression;

		write-verbose "removing solution module $($script:currentSolutionModule.Name)";
		$script:currentSolutionModule | remove-module;
		$script:currentSolutionModule = $null;
	}
}

@(
	# each hash entry defines:
	#	source: the event source object
	#	event: the name of the event raised by the source object
	#		on which to update the list of per-solution scripts
	#	action: the scriptblock to execute on the event

	# manage solutionEvents.Opened:
	#	update path to include project script repository
	#	import the solution module, if present
	@{	
		source = $solutionEvents;
		event = 'Opened';
		action = { 
			write-debug 'solution open detected...';
			try
			{	
				update-SolutionScriptRepository; 
				import-solutionModule; 
			}
			catch
			{
				write-debug 'an error has occurred during solution open event handling ...';
				$_ | write-error;
			}
		};
	},
	
	@{
		source = $solutionEvents;
		event = 'BeforeClosing';
		action = { 
			write-debug 'solution closing detected...';
			remove-solutionModule; 
			clear-SolutionScriptRepository; 			
		};
	}	
) | foreach {
	write-verbose ('action: ' + $_.action );
	
	write-debug "registering to handle $($_.event) on $($_.source)";
	register-objectEvent $_.source -eventname $_.event -action $_.action | out-null;	
};

update-SolutionScriptRepository; 
import-solutionModule;
