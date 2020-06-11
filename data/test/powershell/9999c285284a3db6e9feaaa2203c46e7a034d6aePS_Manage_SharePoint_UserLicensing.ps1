############################################################################################################################################
# Script that allows to manage User Licensing in a SharePoint Farm
# Required Parameters:
#   ->$sOperationType: Operation Type.
############################################################################################################################################

If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

#We make a good usage of PowerShell in terms of performance
$host.Runspace.ThreadOptions = "ReuseThread"

#Definition of the function that allows to manage User Licensing in a SharePoint Farm
function Manage-UserLicensing
{
    param ($sOperationType)
    try
    {
        switch ($sOperationType) 
        { 
        "GetLicenses" {
            Write-Host "Getting the List of User Licenses available in the farm" -ForegroundColor Green
            Get-SPUserLicense

            }
        "GetUserLicensingStatus"{            
            $SPUSerLicensingStatus=Get-SPUserLicensing           
            Write-Host " "
            if($SPUSerLicensingStatus.Enabled -eq $true){
                Write-Host "User Licensing Status in the Farm: Enabled" -ForegroundColor Green
                }
            else{
                Write-Host "User Licensing Status in the Farm: Disabled" -ForegroundColor Green
                }
            }
        "Enable"{            
            Write-Host "Enabling User Licensing in the Farm" -ForegroundColor Green
            Enable-SPUserLicensing -Confirm:$false
            Write-Host "User Licensing enabled in the Farm" -ForegroundColor Green
            }
        "Disable"{
            Write-Host "Disabling User Licensing in the Farm" -ForegroundColor Green
            Disable-SPUserLicensing -Confirm:$false
            Write-Host "User Licensing disabled in the Farm" -ForegroundColor Green
            }
        default{
            Write-Host "Requested operation is not valid" -ForegroundColor Red
            }           
        }   
    }
    catch [System.Exception]
    {
        write-host -ForegroundColor Red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global
#Managin User Licensing Status through the different cases included in the Switch-Case clause
Manage-UserLicensing -sOperationType "GetLicenses"
Manage-UserLicensing -sOperationType "GetUserLicensingStatus"
Manage-UserLicensing -sOperationType "Enable"
Manage-UserLicensing -sOperationType "Disable"

Manage-UserLicensing -sOperationType "GetUserLicensingStatus"
Stop-SPAssignment –Global
Remove-PSSnapin Microsoft.SharePoint.PowerShell