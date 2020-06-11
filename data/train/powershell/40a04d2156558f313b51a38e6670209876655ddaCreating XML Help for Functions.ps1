$demoFunctionsFolder = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\building-advanced-powershell-functions-and-modules\building-advanced-powershell-functions-and-modules-m7\Demos\XML Help\Individual Functions'

## Show demo functions
ise "$demoFunctionsFolder\functions.ps1"

## dot source the demo functions
. "$demoFunctionsFolder\functions.ps1"

## No help exists This is auto-generated help.
Get-Help -Name Get-VirtualMachine

## Add .EXTERNALHELP to both functions
## Notice no path --looks for the XML file in the same folder
# .EXTERNALHELP demofunction-help.xml

## Show the XML file
ise "$demoFunctionsFolder\demofunction-help.xml"

## reload session -- help is cached and reloaded only at a new session
## I will copy over these 3 lines and run again since it's a new session
## $demoFunctionsFolder = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\building-advanced-powershell-functions-and-modules\building-advanced-powershell-functions-and-modules-m5\Demos\XML Help\Individual Functions'
## . "$demoFunctionsFolder\functions.ps1"
## Get-Help -Name Get-VirtualMachine


