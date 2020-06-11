# The basis for this script is described here
# http://blogs.msdn.com/b/visualstudioalm/archive/2014/04/16/new-agent-for-application-insights-available.aspx
# The scripts can be downloaded directly from
# http://go.microsoft.com/fwlink/?LinkID=329971

#Constants
$downloadUrl = "https://go.microsoft.com/fwlink/?LinkID=512247&clcid=0x409"

# Variables
$rootDir = Split-Path $MyInvocation.MyCommand.Path
$downloadPath = Join-Path $rootDir "ApplicationInsightsAgent.msi"

# Functions
# Infrastructure functions
function TryV1
{
    param
    (
        [ScriptBlock] $Command = $(throw "The parameter -Command is required."),
        [ScriptBlock] $Catch   = { throw $_ },
        [ScriptBlock] $Finally = { }
    )

    & {
        $local:ErrorActionPreference = "SilentlyContinue"

        trap
        {
            trap
            {
                & {
                    trap { throw $_ }
                    & $Finally
                }

                throw $_
            }

            $_ | & { & $Catch }
        }

        & $Command
    }

    & {
        trap { throw $_ }
        & $Finally
    }
}

function Retry
{
    param (
        [ScriptBlock] $RetryCommand
    )

    for ($attempts=0; $attempts -lt 5; $attempts++)
    {        
        TryV1 {

            & $RetryCommand
            break

        } -Catch {

            if($attempts -lt 4)
            {
                Log-Message "Attempt:$attempts Exception Occured. Sleeping and Retrying..."
                Log-Message $_
                Log-Message $_.InvocationInfo.PositionMessage
                Start-Sleep -Seconds 1
            }
            else
            {
                throw $_
            }
        }
    }

}

function Log-Message
{
    param(
        [string] $message
    )

    $logString = ("{0}: {1}" -f (Get-Date), $message)
    $unifiedStartupInfoLogPath = Join-Path $rootDir "ApmAgentInstall.log"
    Add-Content $unifiedStartupInfoLogPath $logString
    Write-Host $logString -ForegroundColor Green
}

function Log-Error
{
    param(
        [string] $message
    )
    $logString =  ("{0}: {1}" -f (Get-Date), $message)
    $unifiedStartupErrorLogPath = Join-Path $rootDir "ApmAgentInstallError.log"
    Add-Content $unifiedStartupInfoLogPath $logString
    Write-Host $logString -ForegroundColor Red
}

# Functions
# Operations functions
function Get-AppInsightsInstallationStatus(){

    if(${env:InstalledStatusMonitor} -eq 1)
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Download-StatusMonitor
{
    Retry {

        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($downloadUrl, $downloadPath)
    }
}

function Install-StatusMonitor(){
    $logPath = Join-Path $rootDir "StatusMonitorInstall.log"
    &$downloadPath /quiet /passive /log $logPath
    Log-Message "Waiting 30 seconds for Status Monitor to finish its install ..."
    Start-Sleep -Seconds 30
}

function Grant-LoggingPermissionToAppPool(){
    $groupName = "Performance Monitor Users"
    $user = "Network Service"
    $group = [ADSI]"WinNT://./$groupName,group"
    if(($group.PSBase.Invoke('Members') | %{$_.GetType().InvokeMember('Name', 'GetProperty', $null, $_, $null)}) -contains $user)
    {
        Log-Message "'$user' is already a member of '$groupName', don't need to do anything"
        return
    }    
    else
    {
        Log-Message "'$user' is now a member of '$groupName'"
        $group.Add("WinNT://$user")
    }
}

function Restart-IISOnAzureWebRole(){
    # For some reason, even though Status Monitor calls "iisreset.exe /restart"
    # calling it here leaves IIS and website stopped.
    &iisreset.exe /restart

    Log-Message "waiting a few seconds..."
    Start-Sleep -Seconds 2
    Log-Message "starting..."

    Start-Service -Name W3SVC
    Get-WebApplication | Select ApplicationPool -Unique | %{ Start-WebAppPool $_.applicationPool }
    Get-Website | Start-Website
    Log-Message "started"
}

# Main body
Log-Message "Starting Status Monitor installation"

Log-Message "Downloading component..."
Download-StatusMonitor

Log-Message "Installing component..."
Install-StatusMonitor

Log-Message "Adding app pool account to the 'Performance Monitor Users' local group"
Grant-LoggingPermissionToAppPool

Log-Message "Stop-Starting services to enable tracing..."
Restart-IISOnAzureWebRole

Log-Message "Completed installation successfully"