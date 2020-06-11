# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector | Select -First 2

# Set Sources
$host.Ui.WriteVerboseLine("Running Synchronize request to set sources")
$param = @{
    Id             = $Collectors.Id
    pathExpression = "C:\logs\Log.log"
    name           = "Log"
    sourceType     = "LocalFile"
    category       = "Log Category"
    description    = "Log Description"
}
Set-PSSumoLogicApiCollectorSource @param -Verbose