# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollector | select -First 5

# obtain Sources and remove it
$collectors `
| %{
    $host.Ui.WriteVerboseLine("Running Asynchronous request to get sources")
    $souces = Get-PSSumoLogicApiCollectorSource -CollectorId $_.id -Async

    # Remove each souces in per Collectors
    $host.Ui.WriteVerboseLine("Running Asynchronous request for each collectorId")
    Remove-PSSumoLogicApiCollectorSource -CollectorId $_.id -Id $souces.id -Async}