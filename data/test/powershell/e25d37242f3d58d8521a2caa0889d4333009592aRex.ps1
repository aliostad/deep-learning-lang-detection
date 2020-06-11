param(
    [Alias('c')]
    [string]$command,
    [Alias('p')]
    [string]$packageName,
    [Alias('d')]
    [string]$directory,
    [Alias('v')]
    [string]$version,
    [Alias('u')]
    [string]$url
)

$scriptRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$packagesRoot = ((Get-Item $scriptRoot).parent.parent.FullName)

Import-Module $scriptRoot\RexModule.psm1

$params = ""
$h1 = "-" * 80

if (!(Test-NullOrEmpty $version)) { $params = "$params -Version $version".Trim() }
if (!(Test-NullOrEmpty $url)) { $params = "$params -URL $url".Trim() }
if (!(Test-NullOrEmpty $directory)) { $params = "$params -Directory $directory".Trim() }

switch -regex ($command) {
    "Install" {
        $script = (Get-ChildItem $packagesRoot -Recurse | ?{$_.Name -Match "$packageName.ps1"} | Select -First 1).FullName

        if (Test-NullOrEmpty $script) {
            Throw "Can't find package with name $packageName to install"
        }

        . $script

        Get-Command "Install-$packageName" -Type Function -ErrorAction Stop | Out-Null
        $command = "Install-$packageName $params"

        Write-Host "Invoking $command" -ForegroundColor Green
        Write-Host $h1 -ForegroundColor Green

        Invoke-Expression $command
    }

    "(help|\-[h]|/[?])" {
        Show-RexHelp
    }

    "Version" {
        Show-Version
    }

    default {
        Show-RexHelp
    }
}
