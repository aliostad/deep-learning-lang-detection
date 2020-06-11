# ---- VC Errors ----
function ShowVIEvents () {
  if ($ShowVIEvents) {
   
   Write-CustomOut "..Checking VI Events"

   $OutputErrors = @(Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$VCEventAge ) -Type Error | Select @{N="Host";E={$_.host.name}}, createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)

    if (($OutputErrors | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $viEventsReport += Get-CustomHeader "Error Events (Last $VCEventAge Day(s)) : $($OutputErrors.count)" "The Following Errors were logged in the vCenter Events tab, you may wish to investigate these"
      $viEventsReport += Get-HTMLTable $OutputErrors
      $viEventsReport += Get-CustomHeaderClose	
    }
  }
  
  return $viEventsReport
}