<#
-------------------------------------------------------------------
Defaults
-------------------------------------------------------------------
#>
$config.buildFileName='default.ps1'
$config.framework = '4.0'
$config.verboseError=$true
$config.coloredOutput = $true

#-------------------------------------------------------------------
#Load modules from .\modules folder and from file my_module.psm1
#-------------------------------------------------------------------
$config.modules=('.\packages\Midori\tools\*.psm1') #'.\modules\*.psm1'

<#
-------------------------------------------------------------------
Use scriptblock for taskNameFormat
-------------------------------------------------------------------
#>
$config.taskNameFormat = {
  param($taskName) "Psake: Executing $taskName at $(get-date)"
}
