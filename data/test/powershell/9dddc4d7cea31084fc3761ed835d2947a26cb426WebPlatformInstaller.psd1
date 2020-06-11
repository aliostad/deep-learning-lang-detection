#
# Module manifest for module 'WebPlatformInstaller'
#
# Generated by: guitarrapc
#
# Generated on: 11/13/2014
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '1.0.2'

# ID used to uniquely identify this module
GUID = '2e85feae-9517-44ab-9536-6309b62b56a6'

# Author of this module
Author = 'guitarrapc'

# Company or vendor of this module
CompanyName = 'guitarrapc'

# Copyright statement for this module
Copyright = '(c) 2014 guitarrapc. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Manage WebPlatformInstaller'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
DotNetFrameworkVersion = '4.0'

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = '4.0.0.0'

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('WebPlatformInstaller.psm1')

# Functions to export from this module
FunctionsToExport = 'Backup-WebPlatformInstallerConfig', 
               'Edit-WebPlatformInstallerConfig', 
               'Reset-WebPlatformInstallerConfig', 
               'Show-WebPlatformInstallerConfig', 
               'Get-WebPlatformInstallerProduct', 
               'Install-WebPlatformInstallerProgram', 
               'Test-WebPlatformInstallerProductIsInstalled'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = 'WebPlatformInstaller'

# Aliases to export from this module
AliasesToExport = '*'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


