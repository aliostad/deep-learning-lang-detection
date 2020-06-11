# Copyright © 2008, Microsoft Corporation. All rights reserved.


# Common library
. .\CL_Utility.ps1

function LoadAssemblyFromNS([string]$namespace)
{
    if([string]::IsNullorEmpty($namespace))
    {
        throw "Invalid namespace"
    }

    [System.Reflection.Assembly]::LoadWithPartialName($namespace) > $null
}

function LoadAssemblyFromPath([string]$scriptPath)
{
    if([String]::IsNullorEmpty($scriptPath))
    {
        throw "Invalid file path"
    }

    $absolutePath = GetAbsolutionPath $scriptPath


[System.Reflection.Assembly]::LoadFile($absolutePath) > $null
}
