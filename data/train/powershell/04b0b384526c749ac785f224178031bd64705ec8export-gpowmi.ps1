# this script is inspired and largely taken 
# from https://github.com/jeremyts/ActiveDirectoryDomainServices/blob/master/Backups/ManageWMIFilters.ps1

function export-gpowmi {

  if(!(Test-Path -Path "$winkeeper_local\gpo-wmi" )){
    New-Item -ItemType directory -Path "$winkeeper_local\gpo-wmi"
  }
  
  $gpo_parent_dir = join-path $winkeeper_local "gpo-wmi"
  $gpo_wmi_file = join-path $gpo_parent_Dir $gpo_wmi_filename

  set-content $gpo_wmi_file $NULL

  $WMIFilters = Get-ADObject -Filter 'objectClass -eq "msWMI-Som"' -Properties "msWMI-Name","msWMI-Parm1","msWMI-Parm2"

  $RowCount = $WMIFilters | Measure-Object | Select-Object -expand count

  if ($RowCount -ne 0) {
    write-host -ForeGroundColor Green "Exporting $RowCount WMI Filters`n"

    foreach ($WMIFilter in $WMIFilters) {
      write-host -ForeGroundColor Green "Exporting the" $WMIFilter."msWMI-Name" "WMI Filter to $gpo_wmi_file`n"
      $NewContent = $WMIFilter."msWMI-Name" + "`t" + $WMIFilter."msWMI-Parm1" + "`t" + $WMIFilter."msWMI-Parm2"
      add-content $NewContent -path $gpo_wmi_file
    }
    write-host -ForeGroundColor Green "An export of the WMI Filters has been stored at $gpo_wmi_file`n"

  } else {
    write-host -ForeGroundColor Green "There are no WMI Filters to export`n"
  } 
}
