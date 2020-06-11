﻿#
# Module manifest for module 'PSWindowsUpdate'
#
# Generated by: Michal Gajda
#
# Generated on: 2011-01-20
#
# Change Log:
# v1.5.2 - Project migration to PSGallery. Added new aliases Install-WindowsUpdate...
# v1.5.1 - Added Add-WUServiceManager and Remove-WUServiceManager to register/unregister updates Service Manager. Add remoting to Get-WURebootStatus.
# v1.5.0 - Added Invoke-WUInstall for pseudo remoting and Update-WUModule to update module.
# v1.4.7 - Added AutoSelectOnly param for automatic accept only `important` updates, ie those  which have the status AutoSelectOnWebsites = true.
# v1.4.6 - Added function Hide-WUUpdate to auto hide updates that meets search criteria.
# v1.4.5 - Changed default search pre crteria isHidden = 0 to show only nothidden updates. Added WithHidden param to get all updates (hidden and not) and removed isNotHidden param (now it is default criteria). Added warning if don`t find any updates.
# v1.4.4 - Added NotCategory, NotKBArticleID, NotTitle param to filter updates that`s not match of these value.
# v1.4.3 - Added isNotHidden param to show only not hidden updates. Default still show whole updates (hidden and not hidden).
# v1.4.2 - Added IgroneReboot param to hide prompt for reboot, but do not reboot automaticaly.
# v1.4.1 - Added ability to define own search criteria. Correct fast ServerSelection param -WindowsUpdate and -MicrosoftUpdate.
# v1.4.0 - Code optimized, new  filtering criteria, simple remote to obtain information about updates.
# v1.3.4 - Fixed typographical bug in Get-WUInstall in type of updates.
# v1.3.3 - Added progress bar in Get-WUInstall.
# v1.3.2 - Fixed small bug in Add-WUOfflineSync.

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '1.5.2.2'

# ID used to uniquely identify this module
GUID = '8ed488ad-7c77-4b33-b06e-32214925163b'

# Author of this module
Author = 'Michal Gajda'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2011 Michal Gajda. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This module contain functions to manage Windows Update Client.'

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
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'PSWindowsUpdate.Format.ps1xml'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = 'PSWindowsUpdate.psm1'

# Functions to export from this module
FunctionsToExport = 'Add-WUOfflineSync', 'Get-WUHistory', 'Get-WUInstall', 'Get-WUInstallerStatus',
					'Get-WUList', 'Get-WURebootStatus', 'Get-WUServiceManager', 'Get-WUUninstall',
					'Hide-WUUpdate', 'Invoke-WUInstall', 'Remove-WUOfflineSync',
					'Add-WUServiceManager','Remove-WUServiceManager'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = 'Install-WindowsUpdate', 'Uninstall-WindowsUpdate', 'Get-WindowsUpdate', 'Hide-WindowsUpdate'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'PSWindowsUpdate.psd1', 'PSWindowsUpdate.psm1', 'PSWindowsUpdate.Format.ps1xml'

# Private data to pass to the module specified in RootModule/ModuleToProcess
# PrivateData = ''

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

