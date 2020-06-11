# To fix the psmodulepath to allow this module, use the following command (modify as necessary)
if (0) {
   $env:PSModulePath += ";"; # Add your code path so you can import the module
   Remove-Module F5 -ErrorAction "SilentlyContinue"; cls; Import-Module F5 -Verbose;
}
#

# Run these commands in the module directory to "test" the module
#    $path = $pwd; $WhatIf = [switch]$false;
#    function Get-ScriptDirectory { return $path; }
#    @("Helpers", "Scripts") | %{ Get-ChildItem -Recurse -Path (Join-Path $(Get-ScriptDirectory) "\$($_)\*.ps1") | %{ . $_; } }
#    $VerbosePreference = "Continue"; $IsVerbose=$true;
#    $DebugPreference = "Continue"; $IsDebug=$true;

#region Load included scripts

$scriptDir = $(Split-Path $($script:MyInvocation.MyCommand.Path));
function Get-ScriptDirectory { 
    $scriptDir;
}

# Load the module sections
@("Helpers", "Scripts") | %{
    Write-Verbose "";
    Write-Verbose "Loading '$_' files";
    Write-Verbose "------------------------------------------------";
    Get-ChildItem -Recurse -Path (Join-Path $(Get-ScriptDirectory) "\$($_)\*.ps1") | %{ . $_; }
}


# Finished loading methods
Write-Verbose "";
Write-Verbose "------------------------------------------------";
Write-Verbose "Finished loading methods";
Write-Verbose "------------------------------------------------";
Write-Verbose "";

#endregion