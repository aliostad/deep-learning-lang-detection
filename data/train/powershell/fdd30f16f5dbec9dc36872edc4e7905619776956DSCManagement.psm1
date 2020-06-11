############################## Configure and load myLog ##############################
<#
$loggingParams = @{
    LoggingPreference = 'Host'
}

#myLog EventLogs
$TestHarnessSourceList = @{

}

try
{
    Initialise-myLog -EventLogSourceList $TestHarnessSourceList
}
catch
{
    Write-Warning 'Unable to initilize myLog'
    Throw $_.exception
}
#>
############################## Load Required Snapins ##############################
<#
if (-not (Get-PSSnapin -Name 'VMware.VimAutomation.Core'))
{
	$errorMessage ="VMware.VimAutomation.Core not loaded." 
    $errorMessage | Write-LogEntry 
    throw $errorMessage
}

if (-not (Get-PSSnapin -Name 'Citrix.Broker.Admin.V1')) 
{
	$errorMessage = "Citrix.Broker.Admin.V1 not loaded." 
    $errorMessage | Write-LogEntry 
    throw $errorMessage
}
#>

################################################ Load all scripts in the 'functions' directory ###########################################################
$ScriptPath = ($MyInvocation.MyCommand | Split-Path)
$DirectoriesToParse = @('functions')

try
{
    Foreach ($directory in $directoriesToParse)
    {
        Get-ChildItem (Join-Path $ScriptPath $directory) | Where-Object { $_.Name -notlike '_*' -and $_.Name -like '*.ps1'} | ForEach { . $_.FullName }
    }
}
catch { "Unable to load module functions. Exiting $_" | Write-LogEntry -Level Error -PassThru | Invoke-Throw }

##########################################################################################################################################################


<#
Configuration SetPullMode
{
    param(
        [string]$PullServerGuid,
        [string]$AgentTargetComputerName,
        [String]$PullServer
        )
    Node $AgentTargetComputerName
    {
        LocalConfigurationManager
        {
            ConfigurationMode = 'ApplyOnly'
            ConfigurationID = $PullServerGuid
            RefreshMode = 'Pull'
            DownloadManagerName = 'WebDownloadManager'
            DownloadManagerCustomData = @{
                ServerUrl = "http://$PullServer`:8080/PSDSCPullServer.svc";
                AllowUnsecureConnection = 'true' }
        }
    }
}

#>

Export-ModuleMember -Function * -Variable *
