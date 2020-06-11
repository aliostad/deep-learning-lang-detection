$SolutionFolder = "./"
$SolutionName = "SP2010.Manage.FileTypes.wsp"

$AdminServiceName = "SPAdminV4"
$IsAdminServiceWasRunning = $true;

Add-PSSnapin microsoft.sharepoint.powershell

if ($(Get-Service $AdminServiceName).Status -eq "Stopped")
{
    $IsAdminServiceWasRunning = $false;
    Start-Service $AdminServiceName       
}

Write-Host


Write-Host "Rectracting solution: $SolutionName" -NoNewline
    $Solution = Get-SPSolution | ? {($_.Name -eq $SolutionName) -and ($_.Deployed -eq $true)}
    if ($Solution -ne $null)
    {
        if($Solution.ContainsWebApplicationResource)
        {
            Uninstall-SPSolution $SolutionName -AllWebApplications -Confirm:$false
        }
        else
        {
            Uninstall-SPSolution $SolutionName -Confirm:$false
        }
    }
    
    while ($Solution.JobExists)
    {
        Start-Sleep 2
    }
Write-Host " - Done."
    
Write-Host "Removing solution: $SolutionName" -NoNewline
    if ($(Get-SPSolution | ? {$_.Name -eq $SolutionName}).Deployed -eq $false)
    {
        Remove-SPSolution $SolutionName -Confirm:$false
    } 
Write-Host " - Done."
Write-Host

Echo Finish