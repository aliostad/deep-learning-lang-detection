## All functions in the module are visible without being loaded yet
Get-Module MyModule -ListAvailable

## Let's only expose all functions that start with New
## Export-ModuleMember New*

Remove-Module MyModule

## The help function doesn't show up under ExportedCommands or Get-Command
Get-Module -Name MyModule -ListAvailable
Get-Command -Module MyModule

## You can restrict function visibility at import time without using Export-ModuleMember
## Remove Export-ModuleMember from the module
Remove-Module MyModule
Import-Module -Name MyModule -Function 'Get-*'

## ALL functions show up under ExportedCommands with Get-Module because it reads the PSM1 file
Get-Module -Name MyModule -ListAvailable

## Only Get-* show up with Get-Command because it's reading functions loaded in memory
Get-Command -Module MyModule
