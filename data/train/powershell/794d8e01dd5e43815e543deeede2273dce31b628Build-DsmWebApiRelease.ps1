function Build-DsmWebApiRelease
{
<#
.SYNOPSIS
  Builds a release of the DsmWebApi project
.DESCRIPTION
  - Builds all the projects in the DsmWebApi.sln solution
  - Creates NuGet packages
.PARAMETER Version
  Version of the project to build
.PARAMETER SourcesDir
  Root sources directory
.PARAMETER OutDir
  Output directory of the build
.EXAMPLE
  Buils :
  Build-DsmWebApiRelease
#>
    param([parameter(Mandatory = $true)][string]$Version
         ,[parameter(Mandatory = $true)][string]$SourcesDir
         ,[parameter(Mandatory = $true)][string]$OutDir
         )

    # Get MSBuild
    $dotNetFrameworkRegKey = "HKLM:\SOFTWARE\Microsoft\.NETFramework"
    $dotNetFrameworkInstallRoot = (Get-ItemProperty -Path $dotNetFrameworkRegKey -Name InstallRoot).InstallRoot
    $dotNetFramework4InstallRoot = (Get-ChildItem $dotNetFrameworkInstallRoot | Where-Object { $_.Name -like "v4.0*" }).FullName
    $msbuild = Join-Path -Path $dotNetFramework4InstallRoot -ChildPath "msbuild.exe"

    # Expand paths
    $SourcesDir = Resolve-Path $SourcesDir
    if (!(Test-Path $OutDir))
    {
        mkdir -p $OutDir
    }

    $OutDir = Resolve-Path $OutDir
    $solutionFile = Join-Path $SourcesDir "DsmWebApi.sln"
    $msbuildLogFile = Join-Path $OutDir "MSBuild.DsmWebApi.log"
    $msbuildConfiguration = "Release"
    $msbuildPlatform = "Any CPU"

    # Update version in SharedAssemblyInfo.cs
    $sharedAssemblyInfoFile = Join-Path $SourcesDir "SharedAssemblyInfo.cs"
    $sharedAssemblyInfo = Get-Content $sharedAssemblyInfoFile
    $sharedAssemblyInfo = $sharedAssemblyInfo -replace "1.0.0.0", "$Version"
    $sharedAssemblyInfo | Set-Content $sharedAssemblyInfoFile -Encoding UTF8

    # Build the project
    &$msbuild `
        /nologo `
        /noconsolelogger `
        $solutionFile `
        /nr:False `
        /fl `
        /flp:"logfile=$msbuildLogFile;encoding=Unicode;verbosity=diagnostic" `
        /m `
        /p:OutDir="$OutDir\\" `
        /p:Configuration="$msbuildConfiguration" `
        /p:Platform="Any CPU" `
        /p:NuGetPackageVersion="$Version"

    # Revert version in SharedAssemblyInfo.cs
    $sharedAssemblyInfo = Get-Content $sharedAssemblyInfoFile
    $sharedAssemblyInfo = $sharedAssemblyInfo -replace "$Version", "1.0.0.0"
    $sharedAssemblyInfo | Set-Content $sharedAssemblyInfoFile -Encoding UTF8
}
