Param(
    [string] $scriptPath
)


#################################################################################################
# Author: Marina Krynina
# Desc:   Functions to support installation of SharePoint updates
#################################################################################################

function CheckForError
{
    # check if error.txt exists. if yes, read it and throw exception
    # This is done to get an error code from the scheduled task.
    $errorFile = "$scriptPath\error.txt"
    if (CheckFileExists($errorFile))
    {
        $error = Get-Content $errorFile
        Remove-Item $errorFile
   
        throw $error
    }
}

############################################################################################
# Main
############################################################################################
# Load Common functions
. .\FilesUtility.ps1
. .\VariableUtility.ps1
. .\PlatformUtils.ps1
. .\LaunchProcess.ps1

Set-Location -Path $scriptPath 

try
{
    $msg = "Start installation of SharePoint update(s)"
    log "INFO: Starting $msg"
    log "INFO: Getting variables values or setting defaults if the variables are not populated."

    # *** setup account 
    $domain = get-domainshortname
    $domainFull = get-domainname
    $user = (Get-VariableValue $ADMIN "agilitydeploy" $true)
    $password = get-serviceAccountPassword -username $user

    # Manage Agility variables
    $patchLocation = $scriptPath + (Get-VariableValue $MWSUPDATES_LOCATION "\InstallMedia\MWSUpdates" $true)
    $patches = (Get-VariableValue $MWSUPDATES_LIST "office*.exe,ubersrv2013*.exe" $true)
    $psConfigReqd = (Get-VariableValue $PSCONFIG_REQUIRED "false" $true)
    
    # Do the work
    $process = "$PSHOME\powershell.exe"
    $argument = "-file $scriptPath\Install\Install-SP2013Update.ps1 -scriptPath $scriptPath -patchLocation $patchLocation -patches `"$patches`" -psConfigReqd $psConfigReqd; exit `$LastExitCode"

    log "INFO: Calling $process under identity $domain\$user"
    log "INFO: Arguments $argument"

    LaunchProcessAsAdministrator $process $argument "$domain\$user" $password

    # DEBUG
    # . .\Install\Install-SP2013Update.ps1 $scriptPath $patchLocation $patches $psConfigReqd

    # Check for error
    CheckForError

    log "INFO: Finished $msg."

    return 0
}
catch
{
    throw "ERROR: $($_.Exception.Message)"
}