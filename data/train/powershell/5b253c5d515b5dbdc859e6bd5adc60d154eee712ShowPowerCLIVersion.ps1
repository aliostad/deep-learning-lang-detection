# Get the latest version of vCenter Update Manager snapins
# http://communities.vmware.com/community/vmtn/vsphere/automationtools/powercli/updatemanager
# As of 2010/12/29 the latest version is 4.1 build 266648 @ http://www.vmware.com/downloads/download.do?downloadGroup=VUM41PCLI
function ShowPowerCLIVersion () {

  if ($ShowPowerCLIVersion) {
  
    $vPowercliVersion = @()

    for ($i = 0; $i -lt $powercliVersion.SnapinVersions.Count; $i++) {
       $myObj = "" | Select Name, Build
       $myObj.Name = $powercliVersion.SnapinVersions[$i].userFriendlyVersion
       $myObj.Build = $powercliVersion.SnapinVersions[$i].Build
       $vPowercliVersion += $myObj
      
      # This is for later; we are creating a variable for the vCenter Update Manager version
      # to be used by $ShowHostVUMNonCompliance check
      if ($powercliVersion.SnapinVersions[$i].userFriendlyVersion -match "Update Manager") { 
        $powerclivumVersion = $powercliVersion.SnapinVersions[$i]
      }
    }
        
    If (($vPowercliVersion | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $powerCLIVersionReport += Get-CustomHeader "PowerCLI Version Information" "Please verify that you are running a version of PowerCLI which relates to your environment.  This script was tested with 4.1 U1 build 332441."
      $powerCLIVersionReport += Get-HTMLTable $vPowercliVersion
      $powerCLIVersionReport += Get-CustomHeaderClose
    }
  }
  
  return $powerCLIVersionReport
}