#Requires -Version "4.0" -Module PackageManagement
#.Notes
#      if you don't have PackageManagement, you can use nuget instead:
#      nuget install libgit2sharp -OutputDirectory .\packages -ExcludeVersion
[CmdletBinding()]
param(
    [Alias("PSPath")]
    [string]$Path = $PSScriptRoot,
    [string]$ModuleName = $(Split-Path $Path -Leaf)
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
Write-Host "SETUP $ModuleName in $Path"


$NuGetApi = 'https://www.nuget.org/api/v2'
$PackagePaths = Get-ChildItem $Path, (Join-Path $Path *\*) -Filter packages.config
if($PackagePaths) {
    if(!($Name = Get-PackageSource | ? Location -match 'nuget.org/api/v2' | % Name)) {
        Write-Warning "Adding NuGet package source"
        $Name = Register-PackageSource NuGet -Location $NuGetApi -ForceBootstrap -ProviderName NuGet | % Name
    }

    # recursively handle packages.config
    foreach($config in $PackagePaths) {
        Write-Verbose "Restore $($config.FullName)"
        $Path = Split-Path $config.FullName
        $null = mkdir $Path\packages\ -Force

        # This recreates nuget's package restore, but hypothetically, with support for any provider
        # E.g.: nuget restore -PackagesDirectory "$Path\packages" -PackageSaveMode nuspec
        foreach($Package in ([xml](Get-Content $config.FullName)).packages.package) {
            if(!$Package.Source) { $Package.Source = $NuGetApi }
            Write-Verbose "Installing $($Package.id) v$($Package.version) from $($Package.Source)"
            $install = Install-Package -Name $Package.id -RequiredVersion $Package.version -Source $Package.Source -Destination $Path\packages -PackageSave nuspec -Force -ErrorVariable failure
            if($failure) {
                throw "Failed to install $($package.id), see errors above."
            }
        }
    }
}
Push-Location $Path
git submodule update --init --recursive
Pop-Location