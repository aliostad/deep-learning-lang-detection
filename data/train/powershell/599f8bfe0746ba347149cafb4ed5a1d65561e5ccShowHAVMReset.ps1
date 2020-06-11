# ---- HA VM reset log ----
function ShowHAVMReset () {

  if ($ShowHAVMReset) {

    Write-CustomOut "..Checking HA VM reset"
    
    $HAVMresetlist = @(Get-VIEvent -maxsamples 100000 -Start ($Date).AddDays(-$HAVMresetold) -type info |?{$_.FullFormattedMessage -match "reset due to a guest OS error"} |select CreatedTime,FullFormattedMessage |sort CreatedTime -Descending)

    If (($HAVMresetlist | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $haVMResetReport += Get-CustomHeader "HA VM reset (Last $HAVMresetold Day(s)) : $($HAVMresetlist.count)" "The following VMs have been restarted by HA in the last $HAVMresetold days"
      $haVMResetReport += Get-HTMLTable $HAVMresetlist
      $haVMResetReport += Get-CustomHeaderClose
    }
  }
  
  return $haVMResetReport
}	