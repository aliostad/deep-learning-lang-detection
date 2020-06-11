# Deploy the Data Elasticity demo on local SQL databases

## Set a SMO Server object to the default instance on the local computer.
$userName = "sa"
$password = "Mcp334264"
$dacName  = "AWMain"

$catalogName = "AWMain"
$dacpacPath = "..\..\DacPacs\AwMain.dacpac"
$dacpacProfilePath = "..\..\DacPacs\AWMain.Deploy.azuredb.publish.xml"
$serverConnectionString = "Data Source=(localdb)\v11.0;Initial Catalog=AWMain;Integrated Security=SSPI;Connection Timeout=30"

add-type -path "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll"
add-type -path "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.Extensions.dll"

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition

## Load the DAC package file.
$dacPackage = [Microsoft.SqlServer.Dac.DacPackage]::Load("$scriptPath\$dacpacPath")

## Load the DAC profile file.
$dacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load("$scriptPath\$dacpacProfilePath")

## Publish
$dacServices =  New-Object Microsoft.SqlServer.Dac.DacServices($serverConnectionString)

## Subscribe to the DAC deployment events.
Register-ObjectEvent -InputObject $dacServices -EventName "Message" -SourceIdentifier "message" -Action {Write-Host `n`nMessage at $(get-date) :: $event.sourceEventArgs.Message }
Register-ObjectEvent -InputObject $dacServices -EventName "ProgressChanged" -SourceIdentifier "progress" -Action {Write-Host Progress at $(get-date) :: $event.sourceEventArgs.Message}

## Deploy the DAC to create the database.
$updateExistingDb = $false
$dacServices.Deploy($dacPackage, $catalogName, $updateExistingDb, $dacProfile.DeployOptions)

Get-EventSubscriber | Unregister-Event
