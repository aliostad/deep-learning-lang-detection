﻿#
# Module manifest for module 'AzureNetworking'
#
# Generated by: Anders Eide
#
# Generated on: 28.08.2014
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '1.0.2'

# ID used to uniquely identify this module
GUID = '16419ef0-a34d-4dd6-be0f-cf7ec56ddb1f'

# Author of this module
Author = 'Anders Eide'

# Company or vendor of this module
CompanyName = 'Anders Eide'

# Copyright statement for this module
Copyright = '(c) 2014 Anders Eide. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This module contains functions to manage Microsoft Azure Network Services
Change Log:
v1.0.0 - 2014-08-28
    - First release to public

v1.0.1 - 2014-09-03
    - Some cleanup, and correction of typos

v1.0.2 - 2014-09-18
    - Split into a more best practice script module. Not a single file
    - Added support for adding and removing local networks
    - Fixed a lot of bugs
    - Enhanced the Write-Verbose output in multiple scripts
    - Removed option for setting ExpressRoute. Did not work anyway. Will fix
    - Remove-AzureNetworkDNSServer
        - Removed error message that comes if script tries to remove a non-existing DNS
    - Set-AzureVirtualNetwork
        - Added support for adding multiple local networks -EnableS2S -addLocalNetwork
        - Added support for removing a local network -DisableS2S -removeLocalNetwork
    - New-AzureVirtualNetwork
        - Added support for adding multiple local networks -EnableS2S -addLocalNetwork'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('Azure')

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('AzureNetworking.psm1')

# Functions to export from this module
FunctionsToExport = 'New-AzureVirtualNetwork','Set-AzureVirtualNetwork','Remove-AzureVirtualNetwork',
    'New-AzureLocalNetwork','Set-AzureLocalNetwork','Remove-AzureLocalNetwork',
    'New-AzureNetworkDNSServer','Remove-AzureNetworkDNSServer'

# Cmdlets to export from this module
# CmdletsToExport = '*'

# Variables to export from this module
# VariablesToExport = '*'

# Aliases to export from this module
# AliasesToExport = '*'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @('AzureNetworking.psd1','AzureNetworking.psm1')

# Private data to pass to the module specified in RootModule/ModuleToProcess
# PrivateData = ''

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

