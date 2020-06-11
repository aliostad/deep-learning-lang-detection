Param(
    [string] $scriptPath,
    [string] $action,
    [string] $INSTALLSET_XML = "ConfigFiles\AirWatch-Install.xml"
)

# Author: Marina Krynina
# ===================================================================================

############################################################################################
# Main
############################################################################################
# set current script location
Set-Location -Path $scriptPath 

# Load Common functions
. .\FilesUtility.ps1
. .\VariableUtility.ps1
. .\PlatformUtils.ps1
. .\ServicesUtility.ps1
. .\Get-SQLInstance.ps1

. .\LoggingV3.ps1 $true $scriptPath "Manage-Reporting-Service.ps1"

try
{
    $startDate = get-date

    Disable-SmartScreen

    $msg = "Start Manage-Reporting-Service"
    log "INFO: Starting $msg"

    $installOption = "Reports"
    $inputFile = (Join-Path $scriptPath $INSTALLSET_XML) 

    if ((CheckFileExists($inputFile )) -eq $false)
    {
        throw "ERROR: $inputFile is specified but missing"
    }

    [xml]$xmlinput = (Get-Content $inputFile)
    $nodes = $xmlinput.SelectNodes("//InstallSet/Install") | where-object {($_.attributes['InstallType'].value).ToUpper() -eq $installOption.ToUpper()} 
    foreach ($node in $nodes) 
    {
        [string]$serverList = $node.attributes['Server'].value
        $servers = $serverList.Split(",")
        $servers | Where-Object { 
            log "INFO: target server $_, current server $env:COMPUTERNAME"
            if((Get-ServerName ($_.Trim())).ToUpper() -eq ($env:COMPUTERNAME).ToUpper()) 
            {
                [string]$instance = $node.attributes['DBInstance'].value
                log "INFO: SQL Instance = $instance"
                
                $rsServiceName = ("ReportServer$" + $instance)
                log "INFO: Report Server  = $rsServiceName"
                
                # check if SSRS is running on the server. If not, exit
                $ssrs = Get-Service -Name $rsServiceName -ErrorAction Stop
                $rsStatus = $ssrs.Status

                log "INFO: Changing status of $rsServiceName from $rsStatus to $action"

                if ($action.ToUpper() -eq "STOP")
                {
                    Stop-Service $rsServiceName
                }
                elseif ($action.ToUpper() -eq "START")
                {
                    Start-Service $rsServiceName
                }
                else
                {
                    throw "ERROR: Unsupported parameter action was passed into the script: $action"
                }

                exit 0
            }
        }
    }

    exit 0
}
catch
{
    log "ERROR: $($_.Exception.Message)"
    throw "ERROR: $($_.Exception.Message)"
}
finally
{
    log "INFO: Finished $msg."
    $endDate = get-date
    $ts = New-TimeSpan -Start $startDate -End $endDate
    log "TIME: Processing Time  - $ts"
}