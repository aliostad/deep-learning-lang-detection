# Script: Server side testing - Common
# Author: Marina Krynina
#################################################################################################
# \USER_PROFILE
#        \TestResults
#        \Logs

try
{
    $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition 
    . .\LoggingV2.ps1 $true $scriptPath "Execute-UnitTest-Server.ps1"

    #do not use Elevated Task, just load the script for debugging
    $DEBUG = $true

    $TESTFRAMEWORKFOLDER = "TestFramework"
    . .\$TESTFRAMEWORKFOLDER\Execute-UnitTest-Server.ps1 $scriptPath
    exit 0
}
catch
{
    $ex = $_.Exception | format-list | Out-String
    log "ERROR: Exception occurred `nException Message: $ex"

    exit 1
} 
