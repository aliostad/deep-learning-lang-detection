# ---- DRS Migrations ----
function ShowDRSMig () {

  if ($ShowDRSMig) {

    Write-CustomOut "..Checking DRS Migrations"
    $DRSMigrations = @(Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$DRSMigrateAge ) | where {$_.Gettype().Name -eq "DrsVmMigratedEvent"} | select createdTime, fullFormattedMessage)

    If (($DRSMigrations | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $drsMigReport += Get-CustomHeader "DRS Migrations (Last $DRSMigrateAge Day(s)) : $($DRSMigrations.count)" "Multiple DRS Migrations may be an indication of overloaded hosts, check resouce levels of the cluster"
      $drsMigReport += Get-HTMLTable $DRSMigrations
      $drsMigReport += Get-CustomHeaderClose
    }
  }
  
  return $drsMigReport
}