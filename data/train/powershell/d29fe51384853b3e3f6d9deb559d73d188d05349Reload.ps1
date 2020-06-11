
# Constants

$VerbosePreference ="SilentlyContinue"
$region = "West Europe"
$uniqueSuffix = "9373470623"
[Environment]::CurrentDirectory = $PSScriptRoot
$ErrorActionPreference  = 'Stop'

$entryEvenHub = "entry"
$exitEvenHub = "exit"
$eventHubs = @($entryEvenHub, $exitEvenHub)

$sqlUser = "tolladmin"
$sqlPwd = "123toll!"
$dbName = "TollDataDB"

$containerName = "tolldata"
$storageAccountName = "tolldata" + $uniqueSuffix

$acc = Get-AzureAccount
if (!$acc)
{
	Add-AzureAccount
}

# Environment
$nsName = "TollData" + $uniqueSuffix
$ns = Get-AzureSBNamespace -Name $nsName


# Run load generator
Write-Host "Start generating events" -ForegroundColor White
$tollAppType = [System.Reflection.Assembly]::LoadFrom($PSScriptRoot +"\\TollApp.exe").GetType("TollApp.Program")
$tollAppType::SendData($ns.ConnectionString, $entryEvenHub, $exitEvenHub, $true)
