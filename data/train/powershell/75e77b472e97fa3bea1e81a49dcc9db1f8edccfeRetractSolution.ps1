Write-Host "Executing Powershell script RetractSolution.ps1"

$SolutionPackageName  = $args[0]

# Load SharePoint Powershell Snap-In
Add-PSSnapin Microsoft.SharePoint.Powershell

# remove previous version of solution package solution package
$solution = Get-SPSolution | where-object {$_.Name -eq $SolutionPackageName}
if ($solution -ne $null) {
  if($solution.Deployed -eq $true){
    Write-Host "Retracting currently deployed version of solution package"
    Uninstall-SPSolution -Identity $SolutionPackageName -Local -Confirm:$false
  }
  else {
    Write-Host "This project's solution package is not currently deployed"
  }

}
