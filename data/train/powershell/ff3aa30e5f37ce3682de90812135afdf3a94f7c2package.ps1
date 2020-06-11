param(
    [string] $majorVersion = "1.0.",
    [string] $minorVersion = "0",
    [string] $apiKey = "",
    [string] $nugetServer = "",
    [string[]] $tasks = @('Pack')
)

Import-Module "$PSScriptRoot\lib\psake\psake.psm1" -Force

function Invoke-Tasks {
    $rootDir = $PSScriptRoot
    $buildFile = "$PSScriptRoot\package.task.ps1"
    $version = $majorVersion + $minorVersion

    $parameters = @{
        "rootDir" = $rootDir;
        "version" = $version;
        "apiKey"  = $apiKey;
        "nugetServer" = $nugetServer;
    }

    Invoke-Psake $buildFile -taskList $tasks -parameters $parameters

    if(-not $psake.build_success) { throw "Package tasks failed!"   }
}

Invoke-Tasks $tasks
