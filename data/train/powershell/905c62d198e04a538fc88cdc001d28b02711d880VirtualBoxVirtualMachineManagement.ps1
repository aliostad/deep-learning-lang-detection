$VBoxManage = 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'
if(!(Test-Path $VBoxManage))
{
  $VBoxManage = 'VBoxManage.exe'
}

function Invoke-VBoxManage
{
  param
  (
    [Parameter(Mandatory=$true)][string]$command,
    [Parameter(Mandatory=$true)][string]$virtualMachine,
    [Parameter(Mandatory=$false)][string]$arguments
  )
  & $VBoxManage $command $virtualMachine $arguments
}

function Start-VirtualBoxVirtualMachine
{
  Write-Host "starting virtualbox virtual machine"
  param
  (
    [Parameter(Mandatory=$true)][string]$virtualMachine,
    [Parameter(Mandatory=$false)][string]$arguments
  )
  Invoke-VBoxManage 'startvm' $virtualMachine '--type', 'headless', $arguments
}

function Shutdown-VirtualBoxVirtualMachine
{
  Write-Host "stopping virtualbox virtual machine"

  param
  (
    [Parameter(Mandatory=$true)][string]$virtualMachine,
    [Parameter(Mandatory=$false)][string]$arguments
  )
  Invoke-VBoxManage 'controlvm' $virtualMachine 'shutdown', $arguments
}

function Get-VirtuamBoxVirtualMachine
{
  param
  (
    [Parameter(Mandatory=$true)] [string] $machineSearch
  )
  Invoke-VBoxManage list vms
}

<#function Send-VirtualBoxVirtualMachineCommand
{
  param
  (

  )
  Invoke-VBoxManage 
}#>
