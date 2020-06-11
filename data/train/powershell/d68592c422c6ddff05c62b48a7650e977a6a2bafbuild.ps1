function CombineMultipleFileToSingle ([string]$InputRootPath, [string]$OutputPath, $Encoding)
{
    try
    {
        $sb = New-Object System.Text.StringBuilder
        $sw = New-Object System.IO.StreamWriter ($OutputPath, $false, [System.Text.Encoding]::$Encoding)

        # Read All functions
        Get-ChildItem $InputRootPath -Recurse -File `
        | Where-Object { -not ($_.FullName.Contains('.Tests.')) } `
        | Where-Object Extension -eq '.ps1' `
        | ForEach-Object {
            $sb.Append((Get-Content -Path $_.FullName -Raw -Encoding utf8)) > $null
            $sb.AppendLine() > $null
            $footer = '# file loaded from path : {0}' -f $_.FullName
            $sb.Append($footer) > $null
            $sb.AppendLine() > $null
            $sb.AppendLine() > $null
        }
    
        # Output into single file
        $sw.Write($sb.ToString());
    }
    finally
    {
        # Dispose and release file handler
        $sb = $null
        $sw.Dispose()
    }
}

$Script:WebPlatformInstaller = [ordered]@{}
$WebPlatformInstaller.name = "WebPlatformInstaller"
$WebPlatformInstaller.ExportPath = Split-Path $PSCommandPath -Parent
$WebPlatformInstaller.modulePath = Split-Path -parent $WebPlatformInstaller.ExportPath
$WebPlatformInstaller.helpersPath = '\functions\'
$WebPlatformInstaller.combineTempfunction = '{0}.ps1' -f $WebPlatformInstaller.name
$WebPlatformInstaller.fileEncode = [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]'utf8'

$WebPlatformInstaller.moduleVersion = "1.0.2"
$WebPlatformInstaller.description = "Manage WebPlatformInstaller";
$WebPlatformInstaller.copyright = "13/Nov/2014-"
$WebPlatformInstaller.RequiredModules = @()
#$WebPlatformInstaller.RequiredAssemblies = @('Microsoft.Web.PlatformInstaller.dll','WebpiCmd-x64.exe')
$WebPlatformInstaller.clrVersion = "4.0.0.0" # .NET 4.0 with StandAlone Installer "4.0.30319.1008" or "4.0.30319.1" , "4.0.30319.17929" (Win8/2012)
$WebPlatformInstaller.variableToExport = "WebPlatformInstaller"

$WebPlatformInstaller.functionToExport = @(
    # Config
        "Backup-WebPlatformInstallerConfig",
        "Edit-WebPlatformInstallerConfig",
        "Reset-WebPlatformInstallerConfig",
        "Show-WebPlatformInstallerConfig",
    # Product
        "Get-WebPlatformInstallerProduct",
        "Install-WebPlatformInstallerProgram",
        "Test-WebPlatformInstallerProductIsInstalled"
)

$script:moduleManufest = @{
    Path = "{0}.psd1" -f $WebPlatformInstaller.name
    Author = "guitarrapc";
    CompanyName = "guitarrapc"
    Copyright = "(c) 2014 guitarrapc. All rights reserved."; 
    ModuleVersion = $WebPlatformInstaller.moduleVersion
    description = $WebPlatformInstaller.description;
    PowerShellVersion = "3.0";
    DotNetFrameworkVersion = "4.0";
    ClrVersion = $WebPlatformInstaller.clrVersion;
    RequiredModules = $WebPlatformInstaller.RequiredModules;
    RequiredAssemblies = $WebPlatformInstaller.RequiredAssemblies;
    NestedModule = "{0}.psm1" -f $WebPlatformInstaller.name
    CmdletsToExport = "*";
    FunctionsToExport = $WebPlatformInstaller.functionToExport
    VariablesToExport = $WebPlatformInstaller.variableToExport;
}

New-ModuleManifest @moduleManufest


# As Installer place on ModuleName\Tools.
$psd1 = Join-Path $WebPlatformInstaller.ExportPath ("{0}.psd1" -f $WebPlatformInstaller.name);
$newpsd1 = Join-Path $WebPlatformInstaller.ModulePath ("{0}.psd1" -f $WebPlatformInstaller.name);
if (Test-Path -Path $psd1)
{
    Get-Content -Path $psd1 -Encoding UTF8 -Raw -Force | Out-File -FilePath $newpsd1 -Encoding default -Force
    Remove-Item -Path $psd1 -Force
}

# Combine all functions into single .ps1
$outputPath = Join-Path $WebPlatformInstaller.modulePath $WebPlatformInstaller.combineTempfunction
$InputRootPath = (Join-Path $WebPlatformInstaller.modulePath $WebPlatformInstaller.helpersPath)
if(Test-Path $outputPath){ Remove-Item -Path $outputPath -Force }
CombineMultipleFileToSingle -InputRootPath $InputRootPath -OutputPath $outputPath -Encoding UTF8