﻿# This psm1 file is purely for development. The build script will recreate this file entirely.

#region Private Variables
# Current script path
[string]$ScriptPath = Split-Path (get-variable myinvocation -scope script).value.Mycommand.Definition -Parent
[bool]$ThisModuleLoaded = $true
#endregion Private Variables

# Module Pre-Load code
. .\src\other\PreLoad.ps1

# Private and other methods and variables
Get-ChildItem '.\src\private' -Recurse -Filter "*.ps1" -File | Sort-Object Name | Foreach { 
    Write-Verbose "Dot sourcing private script file: $($_.Name)"
    . $_.FullName
}

# Load and export public methods
Get-ChildItem '.\src\public' -Recurse -Filter "*.ps1" -File | Sort-Object Name | Foreach { 
    Write-Verbose "Dot sourcing public script file: $($_.Name)"
    . $_.FullName

    # Find all the functions defined no deeper than the first level deep and export it.
    # This looks ugly but allows us to not keep any uneeded variables in memory that are not related to the module.
    ([System.Management.Automation.Language.Parser]::ParseInput((Get-Content -Path $_.FullName -Raw), [ref]$null, [ref]$null)).FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false) | Foreach {
        Export-ModuleMember $_.Name
    }
}

# Module Post-Load code
. .\src\other\PostLoad.ps1