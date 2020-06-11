#####################################################################
## CmdEnvironment - Module: Node
#####################################################################
## See LICENCE for details
##
## Authors:
## - Aren Blondahl (Reanmachine)

Function Enable-NodeEnvironment
{
    <#

    .SYNOPSIS
    Enable node.js in the environment

    .DESCRIPTION
    Enables a specific version of node.js in the environment.

    .PARAMETER NodePath
    The path to the node.js folder

    .PARAMETER NpmPath
    (Optional) The path to the desired npm repository

    .PARAMETER ShowBanner
    (Optional) Show the version / banner + features display for php.

    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,Mandatory=1)][string]$NodePath,
        [Parameter(Position=1,Mandatory=0)][string]$NpmPath = $Null,
        [Parameter(Position=2,Mandatory=0)][switch]$ShowBanner = $False
    )

    if (Check-IsNullOrEmpty $NpmPath)
    {
        $NpmPath = Join-Path $env:APPDATA 'npm'
    }

    $NodeExecutablePath = Find-NodeExecutable $NodePath
    $NodeVersion = Get-NodeVersion $NodeExecutablePath

    if (!(Test-Path $NpmPath))
    {
        throw ('Unable to find npm at {0}' -f $NpmPath)
    }

    Register-EnvironmentVariable 'PATH' $NodePath -Prepend
    Register-EnvironmentVariable 'PATH' $NpmPath -Prepend

    if ($ShowBanner)
    {
        $Features = @()
        $Features += @('NPM Repository = {0}' -f $NpmPath)
        
        Write-ItemBanner 'Node.js' -Version $NodeVersion -Features $Features
    }
}

Function Get-NodeVersion
{
    <#

    .SYNOPSIS
    Get the version of node.js installed at a location.

    .PARAMETER NodeExecutablePath
    The path to the node.js executable (node.exe)

    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,Mandatory=1)][string]$NodeExecutablePath
    )

    $Version = $Null
    $VersionBanner = & $NodeExecutablePath -v
    
    if (!(Check-IsNullOrEmpty $VersionBanner))
    {
        $Version = $VersionBanner.SubString(1)
    }

    return $Version
}

Function Find-NodeExecutable
{
    <#

    .SYNOPSIS
    Find the nodejs executable path

    .PARAMETER NodePath
    The path to the node.js root folder to search

    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,Mandatory=1)][string]$NodePath
    )

    if (!(Test-Path $NodePath))
    {
        throw ('Unable to find node.js at {0}' -f $NodePath)
    }
    
    $NodeExecutablePath = Join-Path $NodePath 'node.exe'

    if (!(Test-Path $NodeExecutablePath))
    {
        throw ('Unable to find node.exe at {0}' -f $PHPPath)
    }

    return $NodeExecutablePath
}