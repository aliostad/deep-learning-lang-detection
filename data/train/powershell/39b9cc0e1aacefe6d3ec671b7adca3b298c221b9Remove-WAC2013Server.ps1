
############################################################################################
# Main
############################################################################################
# Load Common functions
. .\FilesUtility.ps1
. .\PlatformUtils.ps1
. .\VariableUtility.ps1
. .\LaunchProcess.ps1

Set-Location -Path $scriptPath 
 
 # Logging must be configured here. otherwise it gets lost in the nested calls# 
 . .\LoggingV2.ps1 $true $scriptPath "Remove-WAC2013Server.ps1"


log "INFO: removing server start"

try
{

    Import-Module OfficeWebApps 
    Remove-OfficeWebAppsMachine

    log "INFO: removing server done"

    return 0
}
catch
{
    
    log "ERROR: $($_.Exception.Message)"
    throw "ERROR: $($_.Exception.Message)"
}