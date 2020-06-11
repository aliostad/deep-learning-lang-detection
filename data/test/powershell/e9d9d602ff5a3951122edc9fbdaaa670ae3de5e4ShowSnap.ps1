# ---- Snapshot Information ----
function ShowSnap () {

  if ($ShowSnap) {
    Write-CustomOut "..Checking Snapshots"
    
    $snapshots = @()
    
    $vm | Get-Snapshot | Where {$_.Created -lt (($Date).AddDays(-$SnapshotAge))} | %{
      $objSnap = $_
      $detail = "" | select VM, SnapshotName, DaysOld, Creator, SizeMB, Created, Description
      $detail.VM = $_.VM.name
      $detail.SnapshotName = $_.Name
      $detail.DaysOld = ((Get-Date) - $_.Created).Days
      $detail.Creator = ($_.VM |get-vievent| where {$_.FullFormattedMessage -eq "Task: Create virtual machine snapshot" -AND $_.CreatedTime -match $objSnap.Created}).UserName
      $detail.sizeMB = $_.SizeMB
      $detail.Created = $_.Created
      $detail.Description = $_.Description
      $snapshots += $detail
    }

    If (($Snapshots | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $showSnapReport += Get-CustomHeader "Snapshots (Over $SnapshotAge Days Old) : $($snapshots.count)" "VMware snapshots which are kept for a long period of time may cause issues, filling up datastores and also may impact performance of the virtual machine."
      $showSnapReport += Get-HTMLTable $Snapshots
      $showSnapReport += Get-CustomHeaderClose
    }
  }
  
  return $showSnapReport
}