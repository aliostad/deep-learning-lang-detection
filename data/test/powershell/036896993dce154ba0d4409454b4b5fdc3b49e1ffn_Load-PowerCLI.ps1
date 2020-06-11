<#
.Synopsis
  Load VMware Modules and or Snapins if they are installed
.Description
  Load PowerCLI when required without having to run the dedicated PowerCLI configuration.
  Add to your Powershell profile for ease of access or dot source file from other PowerCLI scripts.
.Notes
  Author: Clint Fritz
#>
function Load-PowerCLI
{
  Write-Verbose "Check if VMware Snapins are already loaded."
  if ( $snapload = Get-PSSnapin | ? { $_.Name -match "vmware" } )
  {
    Write-Output "$($snapload.Count) VMware Snapins already loaded."
  } else {
    Write-Verbose "Load Snapins"
    $snapins = Get-PSSnapin -Registered | ? { $_.Name -match "vmware" } | Add-PSSnapin -PassThru

    if ($snapins)
    {
      Write-Output "$($snapins.Count) VMware Snapins loaded."
    } #end if snapins

  } #end if snapload

  Write-Verbose "Check if VMware Modules are already loaded."
  if ( $moduleload = Get-Module | ? { $_.Name -match "vmware" } )
  {
    Write-Output "$($moduleload.Count) VMware Modules already loaded."
  } else {
    Write-Verbose "Load modules"
    $modules = Get-Module -ListAvailable | ? { $_.Name -match "vmware" } | Import-Module -PassThru

    if ($modules)
    {
      Write-Output "$($modules.Count) VMware modules loaded."
    } #end if modules

  } #end if moduleload  

  Write-Verbose "Final check if any VMware products are present"
  if ( $($snapload.Count) + $($snapins.Count) + $($moduleload.Count) + $($modules.Count) -lt 1 )
  {
    Write-Error -Message "No VMware Snapins or Modules could be found on this system."
  } #end if counts

} #end function Load-PowerCLI
