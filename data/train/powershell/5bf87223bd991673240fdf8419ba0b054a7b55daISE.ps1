
# pr_include (code_to_load_a_file ("$($PSScriptRoot)\ISECreamBasic\ISECreamBasic.psm1") )
# pr_include (code_to_load_a_file ("$($PSScriptRoot)\ShowUI\ShowUI.psm1") )
# pr_include (code_to_load_a_file ("$($PSScriptRoot)\ISEFileExplorer\ISEFileExplorer.psm1") )
# pr_include (code_to_load_a_file ("$($PSScriptRoot)\ISEScriptingGeek\ISEScriptingGeek.psm1") )
<#
Register-ObjectEvent : Cannot subscribe to event. A subscriber with source identifier 'ISEChangeLog_ISE_SCRIPTI
NG_GEEK' already exists.
At C:\projects\ready_bake\pratom\vendor\ISE\ISEScriptingGeek\Set-ISEMostRecent.ps1:80 char:1
+ Register-ObjectEvent $psise.CurrentPowerShellTab.Files -EventName collectionchan ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (Microsoft.Power...EFileCollection:ISEFileCollection) [Register-ObjectEvent], ArgumentException
    + FullyQualifiedErrorId : SUBSCRIBER_EXISTS,Microsoft.PowerShell.Commands.RegisterObjectEventCommand
#>



<# Would not load DLL                # pr_include (code_to_load_a_file ("$($PSScriptRoot)\FunctionExplorer\FunctionExplorer.psm1") ) #>
<# Loaded in ISE, then crashed ISE   # pr_include (code_to_load_a_file ("$($PSScriptRoot)\VariableExplorer\VariableExplorer.psm1") ) #>