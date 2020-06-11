$Now = Get-Date
$Days = "8"
$TargetFolder = "C:\inetpub\teamcity-branch"
$LastWrite = $Now.AddDays(-$Days)

$ROOT_DIRECTORY = "C:\inetpub\teamcity-branch"
$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

# $site = "Default Web site\tc-branch\$normalizedBranchName"
$appPool = "$normalizedBranchName"

$apps = @(
    "Admissions",
    "AdmissionsAPI",
    "AdmissionsReferees",
    "Appointments",
    "ClickR",
    "Ldap.API",
    "Portal",
    "PortalAPI",
    "PortalWidget",
    "Presences",
    "PresencesAPI",
    "Presences.Public",
    "Recognition",
    "Reports",
    "ResetPasswordAPI",
    "ResetPassword",
    "ValidatorFields"
)


$Folders = get-childitem -path $TargetFolder | 
Where {$_.psIsContainer -eq $true} | 
Where {$_.LastWriteTime -le "$LastWrite"} 

write-output $Lastwrite >> log.txt

# EACH FOLDER OLDER THAN XXX DAYS
foreach ($Folder in $Folders)
{
    $site = "Default Web site\tc-branch\$Folder"
    Write-output "-----------------" >> log.txt
    Write-output $site >> log.txt
    # pause

    # REMOVE EACH APPLICATION INSIDE THE FOLDER-BRANCH
    foreach ($app in $apps)
    {
        Write-output $app >> log.txt
        # Remove-WebApplication -Name $app -Site $site -Verbose -ErrorAction Ignore
    }
    $appPool = $Folder.name
    
    # REMOVE EACH APPLICATION POOL OF THE FOLDER-BRANCH TO DELETE
    Write-output "Deleting application pool " $appPool >> log.txt
    # Remove-WebAppPool -Name $appPool -Verbose -ErrorAction Ignore
    
    # REMOVE FOLDER
    write-output "deleting folder" $TargetFolder\$Folder >> log.txt
    # Remove-Item $TargetFolder\$Folder -force -recurse -Confirm:$false -ErrorAction Ignore
}