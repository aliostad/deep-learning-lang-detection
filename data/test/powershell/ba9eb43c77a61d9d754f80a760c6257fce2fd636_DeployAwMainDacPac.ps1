# Deploy the Data Elasticity demo on Azure SQL databases

$connectionString = "Server=tcp:$serverName.database.windows.net,1433;Database=master;User ID=$userName@$serverName;Password=$password;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;"

$dacName  = "AWMain"
$catalogName = "AWMain"
$dacpacPath = "..\..\DacPacs\AwMain.dacpac"
$dacpacProfilePath = "..\..\DacPacs\AWMain.Deploy.azuredb.publish.xml"

add-type -path "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll"
add-type -path "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.Extensions.dll"

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition

## Load the DAC package file.
$dacPackage = [Microsoft.SqlServer.Dac.DacPackage]::Load("$scriptPath\$dacpacPath")

## Load the DAC profile file.
$dacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load("$scriptPath\$dacpacProfilePath")

## Publish
$dacServices =  New-Object Microsoft.SqlServer.Dac.DacServices($connectionString)

## Subscribe to the DAC deployment events.
Register-ObjectEvent -InputObject $dacServices -EventName "Message" -SourceIdentifier "message" -Action {Write-Host `n`nMessage at $(get-date) :: $event.sourceEventArgs.Message }
Register-ObjectEvent -InputObject $dacServices -EventName "ProgressChanged" -SourceIdentifier "progress" -Action {Write-Host Progress at $(get-date) :: $event.sourceEventArgs.Message}

## Deploy the DAC to create the database.
$updateExistingDb = $false
$dacServices.Deploy($dacPackage, $catalogName, $updateExistingDb, $dacProfile.DeployOptions)

Get-EventSubscriber | Unregister-Event
