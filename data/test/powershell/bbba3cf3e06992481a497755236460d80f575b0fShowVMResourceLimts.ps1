# ---- Virtual Machines with Resource Limits ----
function ShowVMResourceLimts () {
  if ($VMResourceLimts) {
   
    Write-CustomOut "..Checking for Resource Limits"

    $VMResourceLimits = @($VM | get-view | where {$_.ResourceConfig.CpuAllocation.Limit -ne -1 -or $_.ResourceConfig.MemoryAllocation.Limit -ne -1} | Select Name, @{N="CPULimit";E={$_.ResourceConfig.CpuAllocation.Limit}}, @{N="MEMLimit";E={$_.ResourceConfig.MemoryAllocation.Limit}} | Sort Name)

    if (($VMResourceLimits | Measure-Object).count -gt 0 -or $ShowAllHeaders){
      $resourceLimtsReport += Get-CustomHeader "Number of VMs with resource limits : $($VMResourceLimits.count)" "VMs with Resource limits"
      $resourceLimtsReport += Get-HTMLTable $VMResourceLimits
      $resourceLimtsReport += Get-CustomHeaderClose
    }
  }
  
  return $resourceLimtsReport
}